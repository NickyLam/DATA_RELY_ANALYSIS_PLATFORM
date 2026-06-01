/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_vouch_acct_flow_ncbsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_vouch_acct_flow_ncbsi1_tm purge;
alter table ${iml_schema}.evt_vouch_acct_flow add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_vouch_acct_flow modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_vouch_acct_flow_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,vouch_flow_num -- 凭证流水号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,check_teller_id -- 检查柜员编号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,card_no -- 卡号
    ,base_amt -- 基础金额
    ,curr_cd -- 币种代码
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_no -- 凭证号码
    ,vouch_status_cd -- 凭证状态代码
    ,vouch_orig_status_cd -- 凭证原状态代码
    ,tran_ref_no -- 交易参考号
    ,ova_flow_num -- 全局流水号
    ,chn_id -- 渠道编号
    ,tran_descb -- 交易描述
    ,tran_id -- 交易编号
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,remark -- 备注
    ,cancel_rs_cd -- 作废原因代码
    ,belong_module -- 所属模块
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_vouch_acct_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_voucher_journal-1
insert into ${iml_schema}.evt_vouch_acct_flow_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,vouch_flow_num -- 凭证流水号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,check_teller_id -- 检查柜员编号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,card_no -- 卡号
    ,base_amt -- 基础金额
    ,curr_cd -- 币种代码
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_no -- 凭证号码
    ,vouch_status_cd -- 凭证状态代码
    ,vouch_orig_status_cd -- 凭证原状态代码
    ,tran_ref_no -- 交易参考号
    ,ova_flow_num -- 全局流水号
    ,chn_id -- 渠道编号
    ,tran_descb -- 交易描述
    ,tran_id -- 交易编号
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,remark -- 备注
    ,cancel_rs_cd -- 作废原因代码
    ,belong_module -- 所属模块
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101045'||P1.VOUCHER_JOURNAL_ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.VOUCHER_JOURNAL_ID -- 凭证流水号
    ,P1.TRAN_DATE -- 交易日期
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.CHECK_USER_ID -- 检查柜员编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.CARD_NO -- 卡号
    ,P1.AMOUNT -- 基础金额
    ,P1.CCY -- 币种代码
    ,P1.DOC_TYPE -- 存款凭证类别代码
    ,P1.VOUCHER_NO -- 凭证号码
    ,P1.VOUCHER_STATUS -- 凭证状态代码
    ,P1.OLD_STATUS -- 凭证原状态代码
    ,P1.REFERENCE -- 交易参考号
    ,P1.CHANNEL_SEQ_NO -- 全局流水号
    ,P1.SOURCE_TYPE -- 渠道编号
    ,P1.TRAN_DESC -- 交易描述
    ,P1.PROGRAM_ID -- 交易编号
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.USER_ID -- 交易柜员编号
    ,P1.REMARK -- 备注
    ,P1.CAN_REASON_CODE -- 作废原因代码
    ,P1.MODULE_ID -- 所属模块
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_voucher_journal' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_voucher_journal p1
where  1 = 1 
    and to_char(p1.tran_date,'yyyymmdd') = '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_vouch_acct_flow truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_vouch_acct_flow exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_vouch_acct_flow_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_vouch_acct_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_vouch_acct_flow_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_vouch_acct_flow', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);