/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_sec_invtry_dtl_ctmsi1
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
drop table ${iml_schema}.evt_sec_invtry_dtl_ctmsi1_tm purge;
alter table ${iml_schema}.evt_sec_invtry_dtl add partition p_ctmsi1 values ('ctmsi1')(
        subpartition p_ctmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_sec_invtry_dtl modify partition p_ctmsi1
    add subpartition p_ctmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_sec_invtry_dtl_ctmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,que_dt -- 查询日期
    ,oper_dt -- 操作日期
    ,trust_org_id -- 托管机构编号
    ,trust_org_name -- 托管机构名称
    ,bond_id -- 债券编号
    ,bond_name -- 债券名称
    ,bond_cate_name -- 债券类别名称
    ,bond_exp_dt -- 债券到期日期
    ,sh_term_post_flg -- 短仓标志
    ,full_price -- 全价
    ,bond_rating_cd -- 债券评级代码
    ,intnal_rating_cd -- 内部评级代码
    ,main_rating_cd -- 主体评级代码
    ,group_group_id -- 群组编号
    ,group_group_name -- 群组名称
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,aval_amt -- 可用金额
    ,bond_debit_crdt_in_amt -- 债券借贷融入金额
    ,bond_debit_crdt_in_aval_amt -- 债券借贷融入可用金额
    ,sec_amt -- 现券金额
    ,sec_aval_amt -- 现券可用金额
    ,agt_repo_amt -- 协议回购金额
    ,fin_amt -- 可融资金额
    ,fin_inpwn_ratio -- 可融资质押比例
    ,pledge_plus_repo_amt -- 质押式正回购金额
    ,inpwn_vch_tot_amt -- 质押券总金额
    ,open_plus_repo_amt -- 开放式正回购金额
    ,open_rev_repo_amt -- 开放式逆回购金额
    ,open_rev_repo_aval_amt -- 开放式逆回购可用金额
    ,td_exp_inpwn_vch_amt -- 当日到期质押券金额
    ,buyout_plus_repo_amt -- 买断式正回购金额
    ,buyout_rev_repo_amt -- 买断式逆回购金额
    ,buyout_rev_repo_aval_amt -- 买断式逆回购可用金额
    ,bond_debit_crdt_inwdraw_lmt -- 债券借贷质押出金额
    ,bond_debit_crdt_wdraw_lmt -- 债券借贷融出金额
    ,trust_vch_tot_amt -- 托管券总金额
    ,manual_adj_post_amt -- 手动调仓金额
    ,evltion_net_price -- 估值净价
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_sec_invtry_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ctms_position_detail-1
insert into ${iml_schema}.evt_sec_invtry_dtl_ctmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,que_dt -- 查询日期
    ,oper_dt -- 操作日期
    ,trust_org_id -- 托管机构编号
    ,trust_org_name -- 托管机构名称
    ,bond_id -- 债券编号
    ,bond_name -- 债券名称
    ,bond_cate_name -- 债券类别名称
    ,bond_exp_dt -- 债券到期日期
    ,sh_term_post_flg -- 短仓标志
    ,full_price -- 全价
    ,bond_rating_cd -- 债券评级代码
    ,intnal_rating_cd -- 内部评级代码
    ,main_rating_cd -- 主体评级代码
    ,group_group_id -- 群组编号
    ,group_group_name -- 群组名称
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,aval_amt -- 可用金额
    ,bond_debit_crdt_in_amt -- 债券借贷融入金额
    ,bond_debit_crdt_in_aval_amt -- 债券借贷融入可用金额
    ,sec_amt -- 现券金额
    ,sec_aval_amt -- 现券可用金额
    ,agt_repo_amt -- 协议回购金额
    ,fin_amt -- 可融资金额
    ,fin_inpwn_ratio -- 可融资质押比例
    ,pledge_plus_repo_amt -- 质押式正回购金额
    ,inpwn_vch_tot_amt -- 质押券总金额
    ,open_plus_repo_amt -- 开放式正回购金额
    ,open_rev_repo_amt -- 开放式逆回购金额
    ,open_rev_repo_aval_amt -- 开放式逆回购可用金额
    ,td_exp_inpwn_vch_amt -- 当日到期质押券金额
    ,buyout_plus_repo_amt -- 买断式正回购金额
    ,buyout_rev_repo_amt -- 买断式逆回购金额
    ,buyout_rev_repo_aval_amt -- 买断式逆回购可用金额
    ,bond_debit_crdt_inwdraw_lmt -- 债券借贷质押出金额
    ,bond_debit_crdt_wdraw_lmt -- 债券借贷融出金额
    ,trust_vch_tot_amt -- 托管券总金额
    ,manual_adj_post_amt -- 手动调仓金额
    ,evltion_net_price -- 估值净价
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401041'||P1.QUERY_DATE -- 事件编号
    ,'9999' -- 法人编号
    ,${iml_schema}.dateformat_max2(P1.QUERY_DATE) -- 查询日期
    ,P1.LAST_MODIFIED -- 操作日期
    ,P1.DEPOSITORY_TRUST -- 托管机构编号
    ,P1.DEPOSITORY_TRUST_NAME -- 托管机构名称
    ,P1.SECURITY_ID -- 债券编号
    ,P1.SECURITY_NAME -- 债券名称
    ,P1.SECURITY_TYPE -- 债券类别名称
    ,${iml_schema}.dateformat_max2(P1.MATURITY_DATE) -- 债券到期日期
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.SHORT_INV END -- 短仓标志
    ,P1.DIRTY_PRICE -- 全价
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.BOND_RATING END -- 债券评级代码
    ,P1.INTERNAL_RATING -- 内部评级代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.SUBJECT_RATING END -- 主体评级代码
    ,P1.INV_GROUP_ID -- 群组编号
    ,P1.INV_GROUP_NAME -- 群组名称
    ,P1.PORTFOLIO_ID -- 投组编号
    ,P1.PORTFOLIO_NAME -- 投组名称
    ,P1.IVT_AMOUNT*10000 -- 可用金额
    ,P1.IVT_BL_B*10000 -- 债券借贷融入金额
    ,P1.IVT_BL_B_AMOUNT*10000 -- 债券借贷融入可用金额
    ,P1.IVT_BOND*10000 -- 现券金额
    ,P1.IVT_BOND_AMOUNT*10000 -- 现券可用金额
    ,P1.IVT_CR_B*10000 -- 协议回购金额
    ,P1.IVT_FUND_AMOUNT*10000 -- 可融资金额
    ,P1.FUND_RATE -- 可融资质押比例
    ,P1.IVT_CR_B*10000 -- 质押式正回购金额
    ,P1.IVT_CR_SUM*10000 -- 质押券总金额
    ,P1.IVT_KR_B*10000 -- 开放式正回购金额
    ,P1.IVT_KR_S*10000 -- 开放式逆回购金额
    ,P1.IVT_KR_S_AMOUNT*10000 -- 开放式逆回购可用金额
    ,P1.IVT_MAT_AMOUNT*10000 -- 当日到期质押券金额
    ,P1.IVT_OR_B*10000 -- 买断式正回购金额
    ,P1.IVT_OR_S*10000 -- 买断式逆回购金额
    ,P1.IVT_OR_SAMOUNT*10000 -- 买断式逆回购可用金额
    ,P1.IVT_SL_B*10000 -- 债券借贷质押出金额
    ,P1.IVT_SL_S*10000 -- 债券借贷融出金额
    ,P1.TRUST_BOND_SUM*10000 -- 托管券总金额
    ,P1.MAN_TRANS_POS*10000 -- 手动调仓金额
    ,P1.MARKET_PRICE -- 估值净价
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_position_detail' -- 源表名称
    ,'ctmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_position_detail p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.SHORT_INV = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'CTMS'
        AND R1.SRC_TAB_EN_NAME= 'CTMS_POSITION_DETAIL'
        AND R1.SRC_FIELD_EN_NAME= 'SHORT_INV'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_SEC_INVTRY_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'SH_TERM_POST_FLG'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.BOND_RATING = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'CTMS'
        AND R2.SRC_TAB_EN_NAME= 'CTMS_POSITION_DETAIL'
        AND R2.SRC_FIELD_EN_NAME= 'BOND_RATING'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_SEC_INVTRY_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'BOND_RATING_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.SUBJECT_RATING = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'CTMS'
        AND R3.SRC_TAB_EN_NAME= 'CTMS_POSITION_DETAIL'
        AND R3.SRC_FIELD_EN_NAME= 'SUBJECT_RATING'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_SEC_INVTRY_DTL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'MAIN_RATING_CD'
where  1 = 1 
     and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_sec_invtry_dtl truncate subpartition p_ctmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_sec_invtry_dtl exchange subpartition p_ctmsi1_${batch_date} with table ${iml_schema}.evt_sec_invtry_dtl_ctmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_sec_invtry_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_sec_invtry_dtl_ctmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_sec_invtry_dtl', partname => 'p_ctmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);