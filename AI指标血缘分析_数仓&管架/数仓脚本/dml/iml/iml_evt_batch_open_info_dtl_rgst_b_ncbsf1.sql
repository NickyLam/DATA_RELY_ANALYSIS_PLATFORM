/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_batch_open_info_dtl_rgst_b_ncbsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.evt_batch_open_info_dtl_rgst_b add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_batch_open_info_dtl_rgst_b partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_tm purge;
drop table ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_op purge;
drop table ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
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
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_batch_open_info_dtl_rgst_b partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_batch_open_info_dtl_rgst_b partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_batch_open_info_dtl_rgst_b partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_batch_open_details-1
insert into ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_tm(
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
    ,nvl(trim(P1.GAIN_TYPE),'-') -- 卡片领取方式代码
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
    ,nvl(trim(P1.DEPOSIT_NATURE),'-') -- 存款性质代码
    ,DECODE(P1.IS_SELL_CHEQUE,'Y','1','N','0','-') -- 允许出售支票标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_batch_open_details' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_batch_open_details p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_tm 
  	                                group by 
  	                                        evt_id
  	                                        ,lp_id
  	                                        ,tran_batch_no
  	                                        ,seq_num
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_cl(
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_op(
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 事件编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.tran_batch_no, o.tran_batch_no) as tran_batch_no -- 交易批次号
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.ova_flow_num, o.ova_flow_num) as ova_flow_num -- 全局流水号
    ,nvl(n.core_flow_num, o.core_flow_num) as core_flow_num -- 核心流水号
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 交易参考号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_subdv_type_cd, o.cust_subdv_type_cd) as cust_subdv_type_cd -- 客户细分类型代码
    ,nvl(n.corp_name, o.corp_name) as corp_name -- 单位名称
    ,nvl(n.open_dt, o.open_dt) as open_dt -- 开立日期
    ,nvl(n.open_org_id, o.open_org_id) as open_org_id -- 开立机构编号
    ,nvl(n.card_draw_way_cd, o.card_draw_way_cd) as card_draw_way_cd -- 卡片领取方式代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.begin_card_no, o.begin_card_no) as begin_card_no -- 起始卡号
    ,nvl(n.termnt_card_no, o.termnt_card_no) as termnt_card_no -- 终止卡号
    ,nvl(n.card_psbook_idf_cd, o.card_psbook_idf_cd) as card_psbook_idf_cd -- 卡折标识代码
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.acct_attr_cd, o.acct_attr_cd) as acct_attr_cd -- 账户属性代码
    ,nvl(n.general_storage_flg, o.general_storage_flg) as general_storage_flg -- 通存标志
    ,nvl(n.general_exch_flg, o.general_exch_flg) as general_exch_flg -- 通兑标志
    ,nvl(n.vouch_type_cd, o.vouch_type_cd) as vouch_type_cd -- 凭证类型代码
    ,nvl(n.vouch_prefix, o.vouch_prefix) as vouch_prefix -- 凭证前缀
    ,nvl(n.vouch_id, o.vouch_id) as vouch_id -- 凭证编号
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.wdraw_way_cd, o.wdraw_way_cd) as wdraw_way_cd -- 支取方式代码
    ,nvl(n.tran_revd_flg, o.tran_revd_flg) as tran_revd_flg -- 交易已冲正标志
    ,nvl(n.batch_proc_status_cd, o.batch_proc_status_cd) as batch_proc_status_cd -- 批次处理状态代码
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.batch_open_type_cd, o.batch_open_type_cd) as batch_open_type_cd -- 批量开立类型代码
    ,nvl(n.memo_code, o.memo_code) as memo_code -- 摘要码
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.int_accr_flg, o.int_accr_flg) as int_accr_flg -- 计息标志
    ,nvl(n.tran_remark_descb, o.tran_remark_descb) as tran_remark_descb -- 交易备注描述
    ,nvl(n.dep_char_cd, o.dep_char_cd) as dep_char_cd -- 存款性质代码
    ,nvl(n.allow_sell_check_flg, o.allow_sell_check_flg) as allow_sell_check_flg -- 允许出售支票标志
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.tran_batch_no is null
            and n.seq_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.tran_batch_no is null
            and n.seq_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.tran_batch_no is null
            and n.seq_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_tm n
    full join (select * from ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.tran_batch_no = n.tran_batch_no
            and o.seq_num = n.seq_num
where (
        o.evt_id is null
        and o.lp_id is null
        and o.tran_batch_no is null
        and o.seq_num is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
        and n.tran_batch_no is null
        and n.seq_num is null
    )
    or (
        o.ova_flow_num <> n.ova_flow_num
        or o.core_flow_num <> n.core_flow_num
        or o.tran_ref_no <> n.tran_ref_no
        or o.cust_id <> n.cust_id
        or o.cust_subdv_type_cd <> n.cust_subdv_type_cd
        or o.corp_name <> n.corp_name
        or o.open_dt <> n.open_dt
        or o.open_org_id <> n.open_org_id
        or o.card_draw_way_cd <> n.card_draw_way_cd
        or o.curr_cd <> n.curr_cd
        or o.begin_card_no <> n.begin_card_no
        or o.termnt_card_no <> n.termnt_card_no
        or o.card_psbook_idf_cd <> n.card_psbook_idf_cd
        or o.prod_id <> n.prod_id
        or o.acct_type_cd <> n.acct_type_cd
        or o.acct_attr_cd <> n.acct_attr_cd
        or o.general_storage_flg <> n.general_storage_flg
        or o.general_exch_flg <> n.general_exch_flg
        or o.vouch_type_cd <> n.vouch_type_cd
        or o.vouch_prefix <> n.vouch_prefix
        or o.vouch_id <> n.vouch_id
        or o.tran_amt <> n.tran_amt
        or o.wdraw_way_cd <> n.wdraw_way_cd
        or o.tran_revd_flg <> n.tran_revd_flg
        or o.batch_proc_status_cd <> n.batch_proc_status_cd
        or o.tran_tm <> n.tran_tm
        or o.batch_open_type_cd <> n.batch_open_type_cd
        or o.memo_code <> n.memo_code
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.int_accr_flg <> n.int_accr_flg
        or o.tran_remark_descb <> n.tran_remark_descb
        or o.dep_char_cd <> n.dep_char_cd
        or o.allow_sell_check_flg <> n.allow_sell_check_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_cl(
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_op(
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.tran_batch_no -- 交易批次号
    ,o.seq_num -- 序号
    ,o.ova_flow_num -- 全局流水号
    ,o.core_flow_num -- 核心流水号
    ,o.tran_ref_no -- 交易参考号
    ,o.cust_id -- 客户编号
    ,o.cust_subdv_type_cd -- 客户细分类型代码
    ,o.corp_name -- 单位名称
    ,o.open_dt -- 开立日期
    ,o.open_org_id -- 开立机构编号
    ,o.card_draw_way_cd -- 卡片领取方式代码
    ,o.curr_cd -- 币种代码
    ,o.begin_card_no -- 起始卡号
    ,o.termnt_card_no -- 终止卡号
    ,o.card_psbook_idf_cd -- 卡折标识代码
    ,o.prod_id -- 产品编号
    ,o.acct_type_cd -- 账户类型代码
    ,o.acct_attr_cd -- 账户属性代码
    ,o.general_storage_flg -- 通存标志
    ,o.general_exch_flg -- 通兑标志
    ,o.vouch_type_cd -- 凭证类型代码
    ,o.vouch_prefix -- 凭证前缀
    ,o.vouch_id -- 凭证编号
    ,o.tran_amt -- 交易金额
    ,o.wdraw_way_cd -- 支取方式代码
    ,o.tran_revd_flg -- 交易已冲正标志
    ,o.batch_proc_status_cd -- 批次处理状态代码
    ,o.tran_tm -- 交易时间
    ,o.batch_open_type_cd -- 批量开立类型代码
    ,o.memo_code -- 摘要码
    ,o.cust_mgr_id -- 客户经理编号
    ,o.int_accr_flg -- 计息标志
    ,o.tran_remark_descb -- 交易备注描述
    ,o.dep_char_cd -- 存款性质代码
    ,o.allow_sell_check_flg -- 允许出售支票标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_bk o
    left join ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.tran_batch_no = n.tran_batch_no
            and o.seq_num = n.seq_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
            and o.tran_batch_no = d.tran_batch_no
            and o.seq_num = d.seq_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_batch_open_info_dtl_rgst_b;
--alter table ${iml_schema}.evt_batch_open_info_dtl_rgst_b truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_batch_open_info_dtl_rgst_b') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_batch_open_info_dtl_rgst_b drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_batch_open_info_dtl_rgst_b modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_batch_open_info_dtl_rgst_b exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_cl;
alter table ${iml_schema}.evt_batch_open_info_dtl_rgst_b exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_batch_open_info_dtl_rgst_b to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_tm purge;
drop table ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_op purge;
drop table ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_batch_open_info_dtl_rgst_b_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_batch_open_info_dtl_rgst_b', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
