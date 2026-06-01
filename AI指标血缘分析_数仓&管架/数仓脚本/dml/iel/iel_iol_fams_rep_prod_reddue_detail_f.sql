: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_rep_prod_reddue_detail_f
CreateDate: 20250603
FileName:   ${iel_data_path}/fams_rep_prod_reddue_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,cdate
,replace(replace(t1.prodid,chr(13),''),chr(10),'') as prodid
,replace(replace(t1.prodcode,chr(13),''),chr(10),'') as prodcode
,replace(replace(t1.prodname,chr(13),''),chr(10),'') as prodname
,replace(replace(t1.profittype,chr(13),''),chr(10),'') as profittype
,replace(replace(t1.profittype_name,chr(13),''),chr(10),'') as profittype_name
,replace(replace(t1.prodseries,chr(13),''),chr(10),'') as prodseries
,replace(replace(t1.prodseries_name,chr(13),''),chr(10),'') as prodseries_name
,replace(replace(t1.invnature,chr(13),''),chr(10),'') as invnature
,replace(replace(t1.invnature_name,chr(13),''),chr(10),'') as invnature_name
,replace(replace(t1.operatemode,chr(13),''),chr(10),'') as operatemode
,replace(replace(t1.operatemode_name,chr(13),''),chr(10),'') as operatemode_name
,replace(replace(t1.periodid,chr(13),''),chr(10),'') as periodid
,replace(replace(t1.vdate,chr(13),''),chr(10),'') as vdate
,replace(replace(t1.mdate,chr(13),''),chr(10),'') as mdate
,replace(replace(t1.term,chr(13),''),chr(10),'') as term
,dueamt
,dueqty
,actamt
,jtglfl
,yjbjjz
,ratelower
,ratelimit
,replace(replace(t1.baserule,chr(13),''),chr(10),'') as baserule
,yieldtermbef
,yieldterm
,clawamt
,glfzfamt
,jtglfamt
,ssglfl
,ceglfl
,sqglfl
,replace(replace(t1.manager,chr(13),''),chr(10),'') as manager
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.is_private_prod,chr(13),''),chr(10),'') as is_private_prod
,replace(replace(t1.privateprod_flag,chr(13),''),chr(10),'') as privateprod_flag
,replace(replace(t1.is_cust_prod,chr(13),''),chr(10),'') as is_cust_prod
,replace(replace(t1.custprod_flag,chr(13),''),chr(10),'') as custprod_flag
,replace(replace(t1.custprodtype,chr(13),''),chr(10),'') as custprodtype
,replace(replace(t1.custprodtype_name,chr(13),''),chr(10),'') as custprodtype_name
,replace(replace(t1.is_min_hold_period,chr(13),''),chr(10),'') as is_min_hold_period
,replace(replace(t1.minholdperiod_flag,chr(13),''),chr(10),'') as minholdperiod_flag
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time

from ${iol_schema}.fams_rep_prod_reddue_detail t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_rep_prod_reddue_detail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
