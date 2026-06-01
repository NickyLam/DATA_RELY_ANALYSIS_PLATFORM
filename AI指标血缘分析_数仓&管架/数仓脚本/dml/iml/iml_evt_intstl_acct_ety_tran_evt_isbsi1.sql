/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_intstl_acct_ety_tran_evt_isbsi1
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
drop table ${iml_schema}.evt_intstl_acct_ety_tran_evt_isbsi1_tm purge;
alter table ${iml_schema}.evt_intstl_acct_ety_tran_evt add partition p_isbsi1 values ('isbsi1')(
        subpartition p_isbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_intstl_acct_ety_tran_evt modify partition p_isbsi1
    add subpartition p_isbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_intstl_acct_ety_tran_evt_isbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,entry_id -- 分录编号
    ,obj_name -- 对象表名称
    ,obj_flow_num -- 对象表流水号
    ,tran_flow_num -- 交易流水号
    ,tran_acct_id -- 交易账户编号
    ,debit_crdt_dir_cd -- 借贷方向代码
    ,entry_curr_cd -- 记账币种代码
    ,entry_amt -- 记账金额
    ,tran_curr_cd -- 交易币种代码
    ,tran_curr_amt -- 交易币种金额
    ,value_dt -- 起息日期
    ,tran_dt -- 交易日期
    ,memo_comnt_1 -- 摘要说明1
    ,sumos_memo -- 传票摘要
    ,memo_comnt_3 -- 摘要说明3
    ,entry_seq_num -- 分录顺序号
    ,exp_status_cd -- 出口状态代码
    ,entry_org_id -- 记账机构编号
    ,dubil_id -- 借据编号
    ,off_bs_acct_id -- 表外账户编号
    ,tran_exch_rat -- 交易汇率
    ,tran_type_cd -- 交易类型代码
    ,intstl_party_id -- 国结当事人编号
    ,wrt_guat_type_cd -- 结售汇类型代码
    ,subj_id -- 科目编号
    ,wrt_guat_tran_type_cd -- 结售汇交易主体类型代码
    ,mdl_p -- 中间价
    ,mdl_p_quot_tm -- 中间价牌价时间
    ,wrt_guat_pl_amt -- 结售汇损益金额
    ,memo_type_cd -- 摘要类型代码
    ,ec_idf_cd -- 钞汇标识代码
    ,tran_cd -- 交易代码
    ,cty_rg_cd -- 国家和地区代码
    ,espec_econ_rg_type_cd -- 特殊经济区内企业类型代码
    ,apprv_id -- 批准编号
    ,cntpty_bank_name -- 交易对手银行名称
    ,sell_exch_rat -- 卖出汇率
    ,buy_exch_rat -- 买入汇率
    ,prefr_point -- 优惠点数
    ,fin_type_cd -- 账务类型代码
    ,sub_acct_num -- 子账号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_intstl_acct_ety_tran_evt
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- isbs_gle-1
insert into ${iml_schema}.evt_intstl_acct_ety_tran_evt_isbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,entry_id -- 分录编号
    ,obj_name -- 对象表名称
    ,obj_flow_num -- 对象表流水号
    ,tran_flow_num -- 交易流水号
    ,tran_acct_id -- 交易账户编号
    ,debit_crdt_dir_cd -- 借贷方向代码
    ,entry_curr_cd -- 记账币种代码
    ,entry_amt -- 记账金额
    ,tran_curr_cd -- 交易币种代码
    ,tran_curr_amt -- 交易币种金额
    ,value_dt -- 起息日期
    ,tran_dt -- 交易日期
    ,memo_comnt_1 -- 摘要说明1
    ,sumos_memo -- 传票摘要
    ,memo_comnt_3 -- 摘要说明3
    ,entry_seq_num -- 分录顺序号
    ,exp_status_cd -- 出口状态代码
    ,entry_org_id -- 记账机构编号
    ,dubil_id -- 借据编号
    ,off_bs_acct_id -- 表外账户编号
    ,tran_exch_rat -- 交易汇率
    ,tran_type_cd -- 交易类型代码
    ,intstl_party_id -- 国结当事人编号
    ,wrt_guat_type_cd -- 结售汇类型代码
    ,subj_id -- 科目编号
    ,wrt_guat_tran_type_cd -- 结售汇交易主体类型代码
    ,mdl_p -- 中间价
    ,mdl_p_quot_tm -- 中间价牌价时间
    ,wrt_guat_pl_amt -- 结售汇损益金额
    ,memo_type_cd -- 摘要类型代码
    ,ec_idf_cd -- 钞汇标识代码
    ,tran_cd -- 交易代码
    ,cty_rg_cd -- 国家和地区代码
    ,espec_econ_rg_type_cd -- 特殊经济区内企业类型代码
    ,apprv_id -- 批准编号
    ,cntpty_bank_name -- 交易对手银行名称
    ,sell_exch_rat -- 卖出汇率
    ,buy_exch_rat -- 买入汇率
    ,prefr_point -- 优惠点数
    ,fin_type_cd -- 账务类型代码
    ,sub_acct_num -- 子账号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104022'|| P1.INR -- 事件编号
    ,'9999' -- 法人编号
    ,P1.INR -- 分录编号
    ,P1.OBJTYP -- 对象表名称
    ,P1.OBJINR -- 对象表流水号
    ,P1.TRNINR -- 交易流水号
    ,P1.ACT -- 交易账户编号
    ,P1.DBTCDT -- 借贷方向代码
    ,NVL(TRIM(P1.CUR),'CNY') -- 记账币种代码
    ,P1.AMT -- 记账金额
    ,NVL(trim(P1.SYSCUR),'CNY') -- 交易币种代码
    ,P1.SYSAMT -- 交易币种金额
    ,P1.VALDAT -- 起息日期
    ,P1.BUCDAT -- 交易日期
    ,P1.TXT1 -- 摘要说明1
    ,P1.TXT2 -- 传票摘要
    ,P1.TXT3 -- 摘要说明3
    ,P1.PRN -- 分录顺序号
    ,P1.EXPFLG -- 出口状态代码
    ,P2.BRANCH -- 记账机构编号
    ,P1.DBTDFT -- 借据编号
    ,P1.PEEACT -- 表外账户编号
    ,P1.RAT -- 交易汇率
    ,nvl(trim(P1.TRDTYP),'000') -- 交易类型代码
    ,P1.CLIEXTKEY -- 国结当事人编号
    ,nvl(trim(P1.WHMTYP),'-') -- 结售汇类型代码
    ,P1.TRMTYP -- 科目编号
    ,nvl(trim(P1.TRNMAN),'00') -- 结售汇交易主体类型代码
    ,P1.MIDRAT -- 中间价
    ,${iml_schema}.timeformat_min(P1.XRTTIM) -- 中间价牌价时间
    ,P1.INCOME -- 结售汇损益金额
    ,P1.SUMTYP -- 摘要类型代码
    ,case when R2.TARGET_CD_VAL is not null then R2.TARGET_CD_VAL else '@'|| P1.CSHFLG end  -- 钞汇标识代码
    ,P1.TRACODE -- 交易代码
    ,case when P1.CTYCODE not like 'Z0%' and  R3.TARGET_CD_VAL is not null then R3.TARGET_CD_VAL when P1.CTYCODE not like 'Z0%' then '@'|| P1.CTYCODE else 'XXX' end  -- 国家和地区代码
    ,case when P1.CTYCODE like 'Z0%' and R4.TARGET_CD_VAL is not null THEN R4.TARGET_CD_VAL when  P1.CTYCODE like 'Z0%' then '@'||P1.CTYCODE  else '99' end -- 特殊经济区内企业类型代码
    ,P1.APVNUM -- 批准编号
    ,P1.OTHFIN -- 交易对手银行名称
    ,P1.SELRAT -- 卖出汇率
    ,P1.BUYRAT -- 买入汇率
    ,P1.bp -- 优惠点数
    ,P1.SETTYP -- 账务类型代码
    ,P1.ACTSEQNO -- 子账号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_gle' -- 源表名称
    ,'isbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_gle p1
    left join ${iol_schema}.isbs_bch p2 on P1.BRANCHINR=p2.inr
and p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CSHFLG=R2.SRC_CODE_VAL
AND R2.SORC_SYS_CD='ISBS'
AND R2.SRC_TAB_EN_NAME='ISBS_GLE'
AND R2.SRC_FIELD_EN_NAME='CSHFLG'
AND R2.TARGET_TAB_EN_NAME='EVT_INTSTL_ACCT_ETY_TRAN_EVT'
AND R2.TARGET_TAB_FIELD_EN_NAME='EC_IDF_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CTYCODE=R3.SRC_CODE_VAL
AND R3.SORC_SYS_CD='ISBS'
AND R3.SRC_TAB_EN_NAME='ISBS_GLE'
AND R3.SRC_FIELD_EN_NAME='CTYCODE'
AND R3.TARGET_TAB_EN_NAME='EVT_INTSTL_ACCT_ETY_TRAN_EVT'
AND R3.TARGET_TAB_FIELD_EN_NAME='CTY_RG_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.CTYCODE=R4.SRC_CODE_VAL
AND R4.SORC_SYS_CD='ISBS'
AND R4.SRC_TAB_EN_NAME='ISBS_GLE'
AND R4.SRC_FIELD_EN_NAME='CTYCODE'
AND R4.TARGET_TAB_EN_NAME='EVT_INTSTL_ACCT_ETY_TRAN_EVT'
AND R4.TARGET_TAB_FIELD_EN_NAME='ESPEC_ECON_RG_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and P1.start_dt=to_date('${batch_date}','yyyy-mm-dd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_intstl_acct_ety_tran_evt truncate subpartition p_isbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_intstl_acct_ety_tran_evt exchange subpartition p_isbsi1_${batch_date} with table ${iml_schema}.evt_intstl_acct_ety_tran_evt_isbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_intstl_acct_ety_tran_evt to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_intstl_acct_ety_tran_evt_isbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_intstl_acct_ety_tran_evt', partname => 'p_isbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);