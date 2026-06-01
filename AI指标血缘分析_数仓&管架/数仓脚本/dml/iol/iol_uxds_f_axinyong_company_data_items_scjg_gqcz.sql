/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_f_axinyong_company_data_items_scjg_gqcz
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz_ex purge;
alter table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz_ex(
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,holdcompany -- 出质人持有股份单位名称
    ,amount -- 出质股权数额
    ,datakeyid -- 数据主键id
    ,scjg_gqcz -- 关联标签
    ,datatype -- 数据类型值
    ,remark -- 备注
    ,idnumber -- 身份证号码
    ,pledgee -- 质权人
    ,registrationauthority -- 登记机关
    ,pledgeeidnumber -- 质权人号码
    ,registrationnumber -- 登记编号
    ,legalperson -- 法定代表人姓名
    ,name -- 出质人
    ,registrationdate -- 登记日期
    ,usccode -- 统一社会信用代码
    ,status -- 状态
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,holdcompany -- 出质人持有股份单位名称
    ,amount -- 出质股权数额
    ,datakeyid -- 数据主键id
    ,scjg_gqcz -- 关联标签
    ,datatype -- 数据类型值
    ,remark -- 备注
    ,idnumber -- 身份证号码
    ,pledgee -- 质权人
    ,registrationauthority -- 登记机关
    ,pledgeeidnumber -- 质权人号码
    ,registrationnumber -- 登记编号
    ,legalperson -- 法定代表人姓名
    ,name -- 出质人
    ,registrationdate -- 登记日期
    ,usccode -- 统一社会信用代码
    ,status -- 状态
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz exchange partition p_${batch_date} with table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_f_axinyong_company_data_items_scjg_gqcz',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);