/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_batch_open
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
drop table ${iol_schema}.ncbs_rb_batch_open_ex purge;
alter table ${iol_schema}.ncbs_rb_batch_open add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_batch_open truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_batch_open_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_batch_open where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_batch_open_ex(
    client_type -- 客户类型
    ,file_name -- 文件名称
    ,file_path -- 文件路径
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,user_id -- 交易柜员编号
    ,withdrawal_type -- 支取方式
    ,appr_flag -- 复核标志
    ,auth_flag -- 授权标志
    ,batch_desc -- 批处理描述
    ,batch_no -- 批次号
    ,batch_status -- 批次处理状态
    ,card_pb_ind -- 卡/折标志
    ,category_type -- 存款人类别
    ,company -- 法人
    ,contact_type -- 联系类型	
    ,copr_name -- 单位名称
    ,error_desc -- 错误描述
    ,failure_number -- 失败数量
    ,gain_type -- 卡片领取方式
    ,mac_value -- 传输密押
    ,open_type -- 批量开立方式
    ,seq_no -- 序号
    ,server_ip -- 后台服务ip
    ,source_branch_no -- 源节点编号
    ,source_type -- 渠道编号
    ,succ_num -- 成功数量
    ,system_id -- 系统id
    ,thread_no -- 线程编号
    ,total_num -- 总数量
    ,tran_mode -- 交易模式
    ,user_lang -- 柜员语言
    ,begin_time -- 开始时间
    ,expire_date -- 失效日期
    ,open_date -- 开立日期
    ,run_date -- 运行日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,appr_user_id -- 复核柜员
    ,auth_user_id -- 授权柜员
    ,dest_branch_no -- 目标机构编号
    ,from_card_no -- 转出卡号
    ,open_branch -- 开立机构
    ,open_ccy -- 批量开户币种
    ,to_card_no -- 终止卡号
    ,total_amt -- 总金额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    client_type -- 客户类型
    ,file_name -- 文件名称
    ,file_path -- 文件路径
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,user_id -- 交易柜员编号
    ,withdrawal_type -- 支取方式
    ,appr_flag -- 复核标志
    ,auth_flag -- 授权标志
    ,batch_desc -- 批处理描述
    ,batch_no -- 批次号
    ,batch_status -- 批次处理状态
    ,card_pb_ind -- 卡/折标志
    ,category_type -- 存款人类别
    ,company -- 法人
    ,contact_type -- 联系类型	
    ,copr_name -- 单位名称
    ,error_desc -- 错误描述
    ,failure_number -- 失败数量
    ,gain_type -- 卡片领取方式
    ,mac_value -- 传输密押
    ,open_type -- 批量开立方式
    ,seq_no -- 序号
    ,server_ip -- 后台服务ip
    ,source_branch_no -- 源节点编号
    ,source_type -- 渠道编号
    ,succ_num -- 成功数量
    ,system_id -- 系统id
    ,thread_no -- 线程编号
    ,total_num -- 总数量
    ,tran_mode -- 交易模式
    ,user_lang -- 柜员语言
    ,begin_time -- 开始时间
    ,expire_date -- 失效日期
    ,open_date -- 开立日期
    ,run_date -- 运行日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,appr_user_id -- 复核柜员
    ,auth_user_id -- 授权柜员
    ,dest_branch_no -- 目标机构编号
    ,from_card_no -- 转出卡号
    ,open_branch -- 开立机构
    ,open_ccy -- 批量开户币种
    ,to_card_no -- 终止卡号
    ,total_amt -- 总金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_batch_open
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_batch_open exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_batch_open_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_batch_open to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_batch_open_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_batch_open',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);