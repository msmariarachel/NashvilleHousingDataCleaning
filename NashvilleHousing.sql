SELECT *
FROM nashvillehousing;

-- Column updates to NULL
SET SQL_SAFE_UPDATES = 0;

SELECT *
FROM nashvillehousing
WHERE HalfBath = '';

UPDATE nashvillehousing
SET PropertyAddress = NULL
WHERE PropertyAddress = '';

UPDATE nashvillehousing
SET OwnerName = NULL
WHERE OwnerName = '';

UPDATE nashvillehousing
SET Bedrooms = NULL
WHERE Bedrooms = '';

UPDATE nashvillehousing
SET FullBath = NULL
WHERE FullBath = '';

UPDATE nashvillehousing
SET HalfBath = NULL
WHERE HalfBath = '';

-- Update SaleDate to standardized date format
SELECT SaleDate
FROM nashvillehousing;

UPDATE nashvillehousing
SET SaleDate = DATE_FORMAT(STR_TO_DATE(SaleDate, '%M %e, %Y'), '%Y-%m-%d');

-- Populate PropertyAddress Data
SELECT PropertyAddress
FROM nashvillehousing
WHERE PropertyAddress is null;

SELECT *
FROM nashvillehousing
ORDER BY ParcelID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, COALESCE(a.PropertyAddress,b.PropertyAddress)
FROM nashvillehousing a
JOIN nashvillehousing b
	on a.ParcelID = b.ParcelID
    and a.UniqueID != b.UniqueID
WHERE a.PropertyAddress is null;

UPDATE nashvillehousing a
JOIN nashvillehousing b
	on a.ParcelID = b.ParcelID
    and a.UniqueID != b.UniqueID
SET a.PropertyAddress = COALESCE(a.PropertyAddress,b.PropertyAddress)
WHERE a.PropertyAddress is null;

-- Break out Address into Individual Columns (Address, City, State)
SELECT PropertyAddress
FROM nashvillehousing;

SELECT
SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress)+1, LENGTH(PropertyAddress)) AS City
FROM nashvillehousing;

ALTER TABLE nashvillehousing
CHANGE PropertyAddress CompletePropertyAddress Nvarchar(255);

ALTER TABLE nashvillehousing
Add Address Nvarchar(255);

UPDATE nashvillehousing
SET Address = SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress)-1);

ALTER TABLE nashvillehousing
Add City Nvarchar(255);

UPDATE nashvillehousing
SET City = SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress)+1, LENGTH(PropertyAddress));

ALTER TABLE nashvillehousing
CHANGE Address PropertyAddress Nvarchar(255);

ALTER TABLE nashvillehousing
CHANGE City PropertyCity Nvarchar(255);

SELECT OwnerAddress
FROM nashvillehousing;

SELECT
SUBSTRING_INDEX(REPLACE(CompleteOwnerAddress, ',', '.'), '.', 1) AS Address,
SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(CompleteOwnerAddress, ',', '.'), '.', -2), '.', 1) AS City,
SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(CompleteOwnerAddress, ',', '.'), '.', -1), '.', 1) AS State
FROM nashvillehousing;

ALTER TABLE nashvillehousing
CHANGE OwnerAddress CompleteOwnerAddress Nvarchar(255);

ALTER TABLE nashvillehousing
Add OwnerAddress Nvarchar(255);

ALTER TABLE nashvillehousing
Add OwnerCity Nvarchar(255);

ALTER TABLE nashvillehousing
Add OwnerState Nvarchar(255);

UPDATE nashvillehousing
SET OwnerAddress = SUBSTRING_INDEX(REPLACE(CompleteOwnerAddress, ',', '.'), '.', 1);

UPDATE nashvillehousing
SET OwnerCity = SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(CompleteOwnerAddress, ',', '.'), '.', -2), '.', 1);

UPDATE nashvillehousing
SET OwnerState = SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(CompleteOwnerAddress, ',', '.'), '.', -1), '.', 1);

-- Change Y/N to Yes/No in SoldAsVacant column
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM nashvillehousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
    END
FROM nashvillehousing;

UPDATE nashvillehousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
    END;

-- Remove duplicates
CREATE TEMPORARY TABLE RowNumCTE(
SELECT *,
    (@row_number := CASE
                    WHEN @prev_parcel_id = ParcelID AND
                         @prev_address = CompletePropertyAddress AND
                         @prev_price = SalePrice AND
                         @prev_date = SaleDate AND
                         @prev_legal = LegalReference
                    THEN @row_number + 1
                    ELSE 1
                    END) AS row_num,
    (@prev_parcel_id := ParcelID) AS prev_parcel_id,
    (@prev_address := CompletePropertyAddress) AS prev_address,
    (@prev_price := SalePrice) AS prev_price,
    (@prev_date := SaleDate) AS prev_date,
    (@prev_legal := LegalReference) AS prev_legal
FROM (SELECT *, UniqueID AS subquery_unique_id FROM nashvillehousing ORDER BY ParcelID, UniqueID) AS subquery,
     (SELECT @row_number := 0) AS r
ORDER BY ParcelID
);

DELETE
FROM RowNumCTE
WHERE row_num > 1;

SELECT *
FROM RowNumCTE
WHERE row_num > 1;

-- Delete Unused Columns
SELECT *
FROM nashvillehousing;

ALTER TABLE nashvillehousing
DROP COLUMN CompletePropertyAddress, DROP COLUMN CompleteOwnerAddress, DROP COLUMN TaxDistrict;

