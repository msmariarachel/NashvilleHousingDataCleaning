# NashvilleHousingDataCleaning


Here's a summary of the data cleaning process along with the tools I used:

Identification of NULL values:

Utilized SQL queries with the tool to identify NULL values in specific columns such as PropertyAddress, OwnerName, Bedrooms, FullBath, and HalfBath.
Cleaning NULL values:

Employed SQL UPDATE statements to set NULL values in columns like PropertyAddress, OwnerName, Bedrooms, FullBath, and HalfBath to NULL to ensure data consistency.
Standardization of date format:

Employed SQL UPDATE statement with DATE_FORMAT and STR_TO_DATE functions to standardize the SaleDate column's format to 'YYYY-MM-DD'.
Populating missing data:

Used SQL queries to identify and populate missing PropertyAddress data based on ParcelID matching between different rows in the dataset.
Address normalization:

Utilized SQL functions like SUBSTRING and LOCATE to break down PropertyAddress into individual columns (Address, City) and renamed columns using ALTER TABLE.
Normalization of owner address:

Applied SQL functions such as SUBSTRING_INDEX and REPLACE to normalize OwnerAddress into individual columns (Address, City, State).
Standardization of categorical data:

Replaced 'Y' and 'N' values in the SoldAsVacant column with 'Yes' and 'No' respectively using CASE statements.
Deduplication:

Employed a temporary table and SQL DELETE statement to remove duplicate records based on specific criteria using a row numbering approach.
Column cleanup:

Finally, removed unused columns such as CompletePropertyAddress, CompleteOwnerAddress, and TaxDistrict from the dataset using SQL ALTER TABLE statements.
This comprehensive data cleaning process ensured data consistency, standardized formats, and prepared the dataset for further analysis or visualization tasks. The tools utilized primarily include SQL queries and functions for data manipulation and transformation.
