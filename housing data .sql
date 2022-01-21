--this file contains the cleaning process of data collected from the tennesse state in the US 




select *
from housing 


--converting the date format
select SaleDateConverted, convert(date,saleDate)
from housing

update housing
set SaleDate = CONVERT(date,SaleDate)

alter table housing
add SaleDateConverted date;

update housing
set SaleDateConverted = CONVERT(date,SaleDate)


--populating blank property addresses 

select a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from housing a
join housing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null


update a
set  PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from housing a
join housing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null


 --breaking adresses into individdual columns
 select PropertyAddress
 from housing

 select 
 SUBSTRING(propertyaddress,1,CHARINDEX(',',PropertyAddress) -1) as address,
	SUBSTRING(propertyaddress,CHARINDEX(',',PropertyAddress) +1,len(PropertyAddress)) as address
 from housing

 alter table housing
add PropertySplitAddress nvarchar(255);

update housing
set PropertysplitAddress = SUBSTRING(propertyaddress,1,CHARINDEX(',',PropertyAddress) -1) 

 alter table housing
add PropertySplitCity nvarchar(255);

update housing
set PropertysplitCity = SUBSTRING(propertyaddress,CHARINDEX(',',PropertyAddress) +1,len(PropertyAddress)) 

select *
from housing



select 
parsename(replace(OwnerAddress,',','.'),3),
parsename(replace(OwnerAddress,',','.'),2),
parsename(replace(OwnerAddress,',','.'),1)
from housing


 alter table housing
add OwnerSplitAddress nvarchar(255);

alter table housing
add OwnerSplitCity nvarchar(255);

 alter table housing
add OwnerSplitState nvarchar(255);

update housing
set OwnerSplitAddress = parsename(replace(OwnerAddress,',','.'),3)

update housing
set OwnerSplitCity =parsename(replace(OwnerAddress,',','.'),2)

update housing
set OwnerSplitState = parsename(replace(OwnerAddress,',','.'),1) 

select *
from housing



--CHANGING YES AND NO IN "SOLD AS VACANT COLUMN"

select distinct(SoldAsVacant),count(soldasvacant)
from housing
group by SoldAsVacant
order by 2

select SoldAsVacant,
	case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
from housing


update housing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end



--REMOVING DUPLICATE VALUES
--Although it may not be required to remove the duplicates but in some cases it may be useful to work with the data
with RownumCTE as(
select *,
	ROW_NUMBER() over(
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
					uniqueID
					) row_num

from housing
--order by ParcelID
)
select *
from RownumCTE
where row_num >1


--DELETE UNUSED COLUMNS
--the raw file is unchanged this is only done for demonstration

select *
from housing

alter table housing
DROP column OwnerAddress,TaxDistrict,PropertyAddress,SaleDate









