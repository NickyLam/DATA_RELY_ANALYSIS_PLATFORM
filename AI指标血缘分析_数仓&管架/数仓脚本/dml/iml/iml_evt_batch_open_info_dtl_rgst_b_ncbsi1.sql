/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_batch_open_info_dtl_rgst_b_ncbsi1
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
drop table ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsi1_tm purge;
alter table ${iml_schema}.evt_batch_open_info_dtl_rgst_b add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_batch_open_info_dtl_rgst_b modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_batch_no -- 交易批次号
    ,seq_num -- 序号
    ,ova_flow_num -- 全局流水号
    ,core_flow_num -- 核心流水号
    ,tran_ref_no -- 交易参考号
    ,cust_id -- 客户编号
    ,cust_subdv_type_cd -- 客户细分类型代码
    ,corp_name -- 单位名称
    ,open_dt -- 开立日期
    ,open_org_id -- 开立机构编号
    ,card_draw_way_cd -- 卡片领取方式代码
    ,curr_cd -- 币种代码
    ,begin_card_no -- 起始卡号
    ,termnt_card_no -- 终止卡号
    ,card_psbook_idf_cd -- 卡折标识代码
    ,prod_id -- 产品编号
    ,acct_type_cd -- 账户类型代码
    ,acct_attr_cd -- 账户属性代码
    ,general_storage_flg -- 通存标志
    ,general_exch_flg -- 通兑标志
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_prefix -- 凭证前缀
    ,vouch_id -- 凭证编号
    ,tran_amt -- 交易金额
    ,wdraw_way_cd -- 支取方式代码
    ,tran_revd_flg -- 交易已冲正标志
    ,batch_proc_status_cd -- 批次处理状态代码
    ,tran_tm -- 交易时间
    ,batch_open_type_cd -- 批量开立类型代码
    ,memo_code -- 摘要码
    ,cust_mgr_id -- 客户经理编号
    ,int_accr_flg -- 计息标志
    ,tran_remark_descb -- 交易备注描述
    ,dep_char_cd -- 存款性质代码
    ,allow_sell_check_flg -- 允许出售支票标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_batch_open_info_dtl_rgst_b
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_batch_open_details-1
insert into ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_batch_no -- 交易批次号
    ,seq_num -- 序号
    ,ova_flow_num -- 全局流水号
    ,core_flow_num -- 核心流水号
    ,tran_ref_no -- 交易参考号
    ,cust_id -- 客户编号
    ,cust_subdv_type_cd -- 客户细分类型代码
    ,corp_name -- 单位名称
    ,open_dt -- 开立日期
    ,open_org_id -- 开立机构编号
    ,card_draw_way_cd -- 卡片领取方式代码
    ,curr_cd -- 币种代码
    ,begin_card_no -- 起始卡号
    ,termnt_card_no -- 终止卡号
    ,card_psbook_idf_cd -- 卡折标识代码
    ,prod_id -- 产品编号
    ,acct_type_cd -- 账户类型代码
    ,acct_attr_cd -- 账户属性代码
    ,general_storage_flg -- 通存标志
    ,general_exch_flg -- 通兑标志
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_prefix -- 凭证前缀
    ,vouch_id -- 凭证编号
    ,tran_amt -- 交易金额
    ,wdraw_way_cd -- 支取方式代码
    ,tran_revd_flg -- 交易已冲正标志
    ,batch_proc_status_cd -- 批次处理状态代码
    ,tran_tm -- 交易时间
    ,batch_open_type_cd -- 批量开立类型代码
    ,memo_code -- 摘要码
    ,cust_mgr_id -- 客户经理编号
    ,int_accr_flg -- 计息标志
    ,tran_remark_descb -- 交易备注描述
    ,dep_char_cd -- 存款性质代码
    ,allow_sell_check_flg -- 允许出售支票标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101074'||P1.BATCH_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.BATCH_NO -- 交易批次号
    ,P1.SEQ_NO -- 序号
    ,P1.CHANNEL_SEQ_NO -- 全局流水号
    ,P1.SUB_SEQ_NO -- 核心流水号
    ,P1.REFERENCE -- 交易参考号
    ,P1.CLIENT_NO -- 客户编号
    ,nvl(trim(P1.CATEGORY_TYPE),'299') -- 客户细分类型代码
    ,P1.COPR_NAME -- 单位名称
    ,P1.OPEN_DATE -- 开立日期
    ,P1.OPEN_BRANCH -- 开立机构编号
    ,P1.GAIN_TYPE -- 卡片领取方式代码
    ,nvl(trim(P1.OPEN_CCY),'-') -- 币种代码
    ,P1.FROM_CARD_NO -- 起始卡号
    ,P1.TO_CARD_NO -- 终止卡号
    ,P1.CARD_PB_IND -- 卡折标识代码
    ,P1.PROD_TYPE -- 产品编号
    ,nvl(trim(P1.ACCT_CLASS),'-') -- 账户类型代码
    ,nvl(trim(P1.ACCT_NATURE),'-') -- 账户属性代码
    ,DECODE(P1.ALL_DEP_IND,'Y','1','N','0','-') -- 通存标志
    ,DECODE(P1.ALL_DRA_IND,'Y','1','N','0','-') -- 通兑标志
    ,P1.DOC_TYPE -- 凭证类型代码
    ,P1.PREFIX -- 凭证前缀
    ,P1.VOUCHER_NO -- 凭证编号
    ,P1.TRAN_AMT -- 交易金额
    ,nvl(trim(P1.WITHDRAWAL_TYPE),'-') -- 支取方式代码
    ,DECODE(P1.REVERSAL_FLAG,'Y','1','N','0','-') -- 交易已冲正标志
    ,P1.BATCH_STATUS -- 批次处理状态代码
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.BATCH_OPEN_TYPE -- 批量开立类型代码
    ,P1.NARRATIVE_CODE -- 摘要码
    ,P1.ACCT_EXEC -- 客户经理编号
    ,DECODE(P1.INT_IND_FLAG,'Y','1','N','0','-') -- 计息标志
    ,P1.TRAN_NOTE -- 交易备注描述
    ,P1.DEPOSIT_NATURE -- 存款性质代码
    ,DECODE(P1.IS_SELL_CHEQUE,'Y','1','N','0','-') -- 允许出售支票标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_batch_open_details' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_batch_open_details p1
where  1 = 1 
    and P1.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND P1.END_DT >TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_batch_open_info_dtl_rgst_b truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_batch_open_info_dtl_rgst_b exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_batch_open_info_dtl_rgst_b to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_batch_open_info_dtl_rgst_b', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);