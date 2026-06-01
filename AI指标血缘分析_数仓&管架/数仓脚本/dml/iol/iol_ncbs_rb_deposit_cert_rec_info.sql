/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_deposit_cert_rec_info
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
drop table ${iol_schema}.ncbs_rb_deposit_cert_rec_info_ex purge;
alter table ${iol_schema}.ncbs_rb_deposit_cert_rec_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_deposit_cert_rec_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_deposit_cert_rec_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_deposit_cert_rec_info where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_deposit_cert_rec_info_ex(
    client_no -- 客户编号
    ,doc_type -- 凭证类型
    ,internal_key -- 账户内部键值
    ,reference -- 交易参考号
    ,user_id -- 交易柜员编号
    ,term -- 存期
    ,term_type -- 期限单位
    ,cert_num -- 证明张数
    ,cert_type -- 存款证明类型
    ,ch_head -- 中文抬头
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,deposit_cert_no -- 存款证明编号
    ,deposit_cert_operate_type -- 存款证明操作类型
    ,deposit_cert_status -- 存款证明状态
    ,en_head -- 英文抬头
    ,prefix -- 前缀
    ,print_cnt -- 打印次数
    ,repair_type -- 补打类型
    ,res_seq_no -- 限制编号
    ,seq_no -- 序号
    ,cancel_date -- 取消日期
    ,cert_end_date -- 证明截止日期
    ,delete_date -- 删除日期
    ,repair_time -- 补打时间
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,auth_user_id -- 授权柜员
    ,cancel_auth_user_id -- 取消授权柜员
    ,cancel_reason -- 撤销原因
    ,cancel_user_id -- 取消柜员
    ,cert_bal -- 证明余额
    ,del_auth_user_id -- 删除授权柜员
    ,del_user_id -- 删除柜员
    ,pre_reference -- 原交易参考号
    ,tran_branch -- 核心交易机构编号
    ,voucher_end_no -- 凭证终止号码
    ,voucher_start_no -- 凭证起始号码
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    client_no -- 客户编号
    ,doc_type -- 凭证类型
    ,internal_key -- 账户内部键值
    ,reference -- 交易参考号
    ,user_id -- 交易柜员编号
    ,term -- 存期
    ,term_type -- 期限单位
    ,cert_num -- 证明张数
    ,cert_type -- 存款证明类型
    ,ch_head -- 中文抬头
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,deposit_cert_no -- 存款证明编号
    ,deposit_cert_operate_type -- 存款证明操作类型
    ,deposit_cert_status -- 存款证明状态
    ,en_head -- 英文抬头
    ,prefix -- 前缀
    ,print_cnt -- 打印次数
    ,repair_type -- 补打类型
    ,res_seq_no -- 限制编号
    ,seq_no -- 序号
    ,cancel_date -- 取消日期
    ,cert_end_date -- 证明截止日期
    ,delete_date -- 删除日期
    ,repair_time -- 补打时间
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,auth_user_id -- 授权柜员
    ,cancel_auth_user_id -- 取消授权柜员
    ,cancel_reason -- 撤销原因
    ,cancel_user_id -- 取消柜员
    ,cert_bal -- 证明余额
    ,del_auth_user_id -- 删除授权柜员
    ,del_user_id -- 删除柜员
    ,pre_reference -- 原交易参考号
    ,tran_branch -- 核心交易机构编号
    ,voucher_end_no -- 凭证终止号码
    ,voucher_start_no -- 凭证起始号码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_deposit_cert_rec_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_deposit_cert_rec_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_deposit_cert_rec_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_deposit_cert_rec_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_deposit_cert_rec_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_deposit_cert_rec_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);