: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_fkd_house_list_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_fkd_house_list.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.city_area_code,chr(13),''),chr(10),'') as city_area_code
,replace(replace(t.city_name,chr(13),''),chr(10),'') as city_name
,replace(replace(t.area_code,chr(13),''),chr(10),'') as area_code
,replace(replace(t.area_name,chr(13),''),chr(10),'') as area_name
,replace(replace(t.project_id,chr(13),''),chr(10),'') as project_id
,replace(replace(t.project_name,chr(13),''),chr(10),'') as project_name
,replace(replace(t.project_addr,chr(13),''),chr(10),'') as project_addr
,replace(replace(t.property_type,chr(13),''),chr(10),'') as property_type
,replace(replace(t.building_code,chr(13),''),chr(10),'') as building_code
,replace(replace(t.floor_no,chr(13),''),chr(10),'') as floor_no
,replace(replace(t.room_no,chr(13),''),chr(10),'') as room_no
,replace(replace(t.hs_decorate_state,chr(13),''),chr(10),'') as hs_decorate_state
,replace(replace(t.front_code,chr(13),''),chr(10),'') as front_code
,replace(replace(t.assessment_com,chr(13),''),chr(10),'') as assessment_com
,t.line_price as line_price
,replace(replace(t.assessment_type,chr(13),''),chr(10),'') as assessment_type
,t.formal_price as formal_price
,t.room_size as room_size
,replace(replace(t.building_date,chr(13),''),chr(10),'') as building_date
,replace(replace(t.pledge_ind,chr(13),''),chr(10),'') as pledge_ind
,replace(replace(t.is_clearing_house,chr(13),''),chr(10),'') as is_clearing_house
,replace(replace(t.is_vacant,chr(13),''),chr(10),'') as is_vacant
,replace(replace(t.is_lease,chr(13),''),chr(10),'') as is_lease
,replace(replace(t.lease_time,chr(13),''),chr(10),'') as lease_time
,replace(replace(t.get_time,chr(13),''),chr(10),'') as get_time
,replace(replace(t.get_mode,chr(13),''),chr(10),'') as get_mode
,replace(replace(t.property_right_due_date,chr(13),''),chr(10),'') as property_right_due_date
,replace(replace(t.hs_obligee_relative,chr(13),''),chr(10),'') as hs_obligee_relative
,replace(replace(t.obligee,chr(13),''),chr(10),'') as obligee
,t.mortgage_amt as mortgage_amt
,replace(replace(t.land_category,chr(13),''),chr(10),'') as land_category
,replace(replace(t.hs_is_basement,chr(13),''),chr(10),'') as hs_is_basement
,t.hs_covered_area as hs_covered_area
,t.hs_overground_area as hs_overground_area
,t.hs_basement_area as hs_basement_area
,replace(replace(t.spare_room_count,chr(13),''),chr(10),'') as spare_room_count
,replace(replace(t.spare_room_is_clearing_house,chr(13),''),chr(10),'') as spare_room_is_clearing_house
,replace(replace(t.spare_room_addr,chr(13),''),chr(10),'') as spare_room_addr
,replace(replace(t.hs_upper_in_mortgage_date,chr(13),''),chr(10),'') as hs_upper_in_mortgage_date
,replace(replace(t.hs_upper_out_mortgage_date,chr(13),''),chr(10),'') as hs_upper_out_mortgage_date
,replace(replace(t.obligee_ind,chr(13),''),chr(10),'') as obligee_ind
,replace(replace(t.partner_obligee_ind,chr(13),''),chr(10),'') as partner_obligee_ind
,replace(replace(t.house_purpose,chr(13),''),chr(10),'') as house_purpose
,replace(replace(t.total_floor,chr(13),''),chr(10),'') as total_floor
,replace(replace(t.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t.pkno,chr(13),''),chr(10),'') as pkno
,replace(replace(t.title_certificate_get_time,chr(13),''),chr(10),'') as title_certificate_get_time
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcrs_fkd_house_list t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_fkd_house_list.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes