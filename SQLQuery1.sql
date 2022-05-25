--Viewing dataset
USE [Nashville Housing]
SELECT * FROM dbo.Sheet1$

--Converting DateTime to Date
SELECT SaleDate, CONVERT(DATE, SaleDate) 
FROM [dbo].[Sheet1$]

ALTER TABLE [dbo].[Sheet1$]
ADD SaleDateConverted DATE

UPDATE [dbo].[Sheet1$]
SET SaleDateConverted = CONVERT(DATE, SaleDate)

SELECT SaleDateConverted
FROM [dbo].[Sheet1$]

SELECT * FROM [dbo].[Sheet1$]

--Populating the PropertyAddress with Owner's Address if it's Null Using a self JOIN

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [dbo].[Sheet1$] AS a
	JOIN [dbo].[Sheet1$] AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [dbo].[Sheet1$] AS a
	JOIN [dbo].[Sheet1$] AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]


SELECT *
FROM [dbo].[Sheet1$]

--Breaking Address into columns (Address, City and State)

SELECT OwnerAddress
FROM [dbo].[Sheet1$]

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS Address
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS City
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS State
FROM [dbo].[Sheet1$]

ALTER TABLE [dbo].[Sheet1$]
ADD Address NVARCHAR(255)

UPDATE [dbo].[Sheet1$]
SET Address = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE [dbo].[Sheet1$]
ADD City NVARCHAR(255)

UPDATE [dbo].[Sheet1$]
SET City = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE [dbo].[Sheet1$]
ADD State NVARCHAR(255)

UPDATE [dbo].[Sheet1$]
SET State = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM [dbo].[Sheet1$]

--Change Y and N to Y and N in SoldAsVacant 

SELECT SoldAsVacant
FROM [dbo].[Sheet1$]

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM [dbo].[Sheet1$]

UPDATE [dbo].[Sheet1$]
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
					WHEN SoldAsVacant = 'N' THEN 'No'
					ELSE SoldAsVacant
					END
FROM [dbo].[Sheet1$]

SELECT *
FROM [dbo].[Sheet1$]

--Viewing Duplicates

WITH RowNumCTE AS(

		SELECT *, ROW_NUMBER() OVER(PARTITION BY ParcelID ORDER BY ParcelID) AS RowNumber
		FROM [dbo].[Sheet1$]
	)

SELECT * FROM RowNumCTE
WHERE RowNumber > 1

--Deleting Unused Columns

ALTER TABLE [dbo].[Sheet1$]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

SELECT * FROM dbo.Sheet1$

