/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_f_axinyong_company_data_items_scjg_gqdj
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
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj_ex purge;
alter table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj_ex(
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,punishmentorgan -- 执行法院
    ,amount -- 被执行人持有股权其他投资权益的数额
    ,idtype -- 被执行人证照/证件类型
    ,datakeyid -- 数据主键id
    ,datatype -- 数据类型值
    ,remark -- 备注
    ,idnumber -- 被执行人证照/证件号码
    ,result -- 执行事项
    ,penaltytime -- 公示日期
    ,executor -- 被执行人
    ,casenumber -- 文书字号
    ,scjg_gqdj -- 关联标签
    ,name -- 股权冻结公司名称
    ,unfreezingdate -- 解除冻结日期
    ,freezeperiod -- 冻结/续行冻结期限
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,punishmentorgan -- 执行法院
    ,amount -- 被执行人持有股权其他投资权益的数额
    ,idtype -- 被执行人证照/证件类型
    ,datakeyid -- 数据主键id
    ,datatype -- 数据类型值
    ,remark -- 备注
    ,idnumber -- 被执行人证照/证件号码
    ,result -- 执行事项
    ,penaltytime -- 公示日期
    ,executor -- 被执行人
    ,casenumber -- 文书字号
    ,scjg_gqdj -- 关联标签
    ,name -- 股权冻结公司名称
    ,unfreezingdate -- 解除冻结日期
    ,freezeperiod -- 冻结/续行冻结期限
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj exchange partition p_${batch_date} with table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_f_axinyong_company_data_items_scjg_gqdj',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);