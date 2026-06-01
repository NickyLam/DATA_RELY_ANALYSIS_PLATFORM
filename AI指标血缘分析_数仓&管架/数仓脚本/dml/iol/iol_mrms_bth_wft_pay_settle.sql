/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_bth_wft_pay_settle
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
drop table ${iol_schema}.mrms_bth_wft_pay_settle_ex purge;
alter table ${iol_schema}.mrms_bth_wft_pay_settle add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mrms_bth_wft_pay_settle truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mrms_bth_wft_pay_settle_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_bth_wft_pay_settle where 0=1;

insert /*+ append */ into ${iol_schema}.mrms_bth_wft_pay_settle_ex(
    clean_date -- 清分日期
    ,clean_id -- 清分ID明细序号
    ,mcht_channel -- 商户号/渠道号
    ,branch_no -- 联行号/网点号
    ,receipt_name -- 收款人姓名
    ,receipt_account -- 收款人账号
    ,receipt_acctype -- 收款人账号类型0-对公，1-对私，2-内部户
    ,clean_amt -- 清分金额
    ,resevel -- 摘要
    ,remark -- 备注
    ,md5 -- 待处理MD5
    ,ok_file_name -- OK文件名称
    ,clear_file_name -- 清算文件名
    ,remark1 -- 备注1
    ,remark2 -- 备注2
    ,remark3 -- 备注3
    ,remark4 -- 备注4
    ,remark5 -- 备注5
    ,ret_serial_no -- 流水号和返回流水
    ,ret_code -- 返回码000 为成功；其他为失败
    ,ret_msg -- 返回信息
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    clean_date -- 清分日期
    ,clean_id -- 清分ID明细序号
    ,mcht_channel -- 商户号/渠道号
    ,branch_no -- 联行号/网点号
    ,receipt_name -- 收款人姓名
    ,receipt_account -- 收款人账号
    ,receipt_acctype -- 收款人账号类型0-对公，1-对私，2-内部户
    ,clean_amt -- 清分金额
    ,resevel -- 摘要
    ,remark -- 备注
    ,md5 -- 待处理MD5
    ,ok_file_name -- OK文件名称
    ,clear_file_name -- 清算文件名
    ,remark1 -- 备注1
    ,remark2 -- 备注2
    ,remark3 -- 备注3
    ,remark4 -- 备注4
    ,remark5 -- 备注5
    ,ret_serial_no -- 流水号和返回流水
    ,ret_code -- 返回码000 为成功；其他为失败
    ,ret_msg -- 返回信息
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mrms_bth_wft_pay_settle
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mrms_bth_wft_pay_settle exchange partition p_${batch_date} with table ${iol_schema}.mrms_bth_wft_pay_settle_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_bth_wft_pay_settle to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mrms_bth_wft_pay_settle_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_bth_wft_pay_settle',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);