/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_am_repo_tran_famsf1
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
drop table ${iml_schema}.agt_am_repo_tran_famsf1_tm purge;
drop table ${iml_schema}.agt_am_repo_tran_famsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_am_repo_tran add partition p_famsf1 values ('famsf1')(
        subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_am_repo_tran modify partition p_famsf1
    add subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_am_repo_tran_famsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_am_repo_tran partition for ('famsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_am_repo_tran_famsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,bus_id -- 业务编号
    ,onl_flg -- 线上标志
    ,tran_dt -- 交易日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,tenor -- 期限
    ,repo_type_cd -- 回购类型代码
    ,repo_dir_cd -- 回购方向代码
    ,curr_cd -- 币种代码
    ,tran_type_cd -- 交易类型代码
    ,repo_int_rat -- 回购利率
    ,int_accr_base_cd -- 计息基准代码
    ,cert_face_tot -- 券面总额
    ,repo_pric_amt -- 回购本金金额
    ,repo_exp_int -- 回购到期利息
    ,exp_pric_int_amt -- 到期本息金额
    ,fir_stl_amt -- 首次结算金额
    ,exp_stl_amt -- 到期结算金额
    ,fir_stl_way_cd -- 首次结算方式代码
    ,exp_stl_way_cd -- 到期结算方式代码
    ,ghb_acct_id -- 本方账户编号
    ,ghb_tran_id -- 本方交易编号
    ,cntpty_acct_id -- 对手方账户编号
    ,cntpty_type_cd -- 对手方类型代码
    ,cntpty_dealer_id -- 对手方交易员编号
    ,asset_flow_dir_cd -- 资产流向代码
    ,pric_dlvy_amt -- 本金交割金额
    ,int_dlvy_amt -- 利息交割金额
    ,int_not_provi_amt -- 利息未计提金额
    ,input_dt -- 录入日期
    ,pay_dt -- 付款日期
    ,asset_dlvy_dt -- 资产交割日期
    ,pay_flg -- 付款标志
    ,valid_flg -- 有效标志
    ,parent_tran_id -- 父交易编号
    ,init_tran_id -- 原交易编号
    ,trans_flow_num -- 转仓流水号
    ,rev_tran_flow_num -- 反向交易流水号
    ,splt_tran_flg -- 拆分交易标志
    ,asset_pool_flg -- 资产池标志
    ,exp_yld_rat -- 到期收益率
    ,tran_market_cd -- 交易市场代码
    ,tran_market_descb -- 交易市场描述
    ,brkevn_flg -- 保本标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_am_repo_tran
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_am_repo_tran_famsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_am_repo_tran partition for ('famsf1') where 0=1;

-- 2.1 insert data to tm table
-- fams_rep_deal-
insert into ${iml_schema}.agt_am_repo_tran_famsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,bus_id -- 业务编号
    ,onl_flg -- 线上标志
    ,tran_dt -- 交易日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,tenor -- 期限
    ,repo_type_cd -- 回购类型代码
    ,repo_dir_cd -- 回购方向代码
    ,curr_cd -- 币种代码
    ,tran_type_cd -- 交易类型代码
    ,repo_int_rat -- 回购利率
    ,int_accr_base_cd -- 计息基准代码
    ,cert_face_tot -- 券面总额
    ,repo_pric_amt -- 回购本金金额
    ,repo_exp_int -- 回购到期利息
    ,exp_pric_int_amt -- 到期本息金额
    ,fir_stl_amt -- 首次结算金额
    ,exp_stl_amt -- 到期结算金额
    ,fir_stl_way_cd -- 首次结算方式代码
    ,exp_stl_way_cd -- 到期结算方式代码
    ,ghb_acct_id -- 本方账户编号
    ,ghb_tran_id -- 本方交易编号
    ,cntpty_acct_id -- 对手方账户编号
    ,cntpty_type_cd -- 对手方类型代码
    ,cntpty_dealer_id -- 对手方交易员编号
    ,asset_flow_dir_cd -- 资产流向代码
    ,pric_dlvy_amt -- 本金交割金额
    ,int_dlvy_amt -- 利息交割金额
    ,int_not_provi_amt -- 利息未计提金额
    ,input_dt -- 录入日期
    ,pay_dt -- 付款日期
    ,asset_dlvy_dt -- 资产交割日期
    ,pay_flg -- 付款标志
    ,valid_flg -- 有效标志
    ,parent_tran_id -- 父交易编号
    ,init_tran_id -- 原交易编号
    ,trans_flow_num -- 转仓流水号
    ,rev_tran_flow_num -- 反向交易流水号
    ,splt_tran_flg -- 拆分交易标志
    ,asset_pool_flg -- 资产池标志
    ,exp_yld_rat -- 到期收益率
    ,tran_market_cd -- 交易市场代码
    ,tran_market_descb -- 交易市场描述
    ,brkevn_flg -- 保本标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '225106'||P1.REPDUUID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.REPDUUID -- 交易流水号
    ,P1.TRADEID -- 业务编号
    ,P1.ISMANAUL -- 线上标志
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.DEALDATE)) -- 交易日期
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.VDATE)) -- 起息日期
    ,${iml_schema}.DATEFORMAT_MAX(to_char(P1.MDATE)) -- 到期日期
    ,P1.TERM -- 期限
    ,P1.PRODTYPE -- 回购类型代码
    ,P1.PS -- 回购方向代码
    ,P1.CCY -- 币种代码
    ,P1.DEALTYPE -- 交易类型代码
    ,P1.REPORATE * 100 -- 回购利率
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.BASIS END -- 计息基准代码
    ,P1.FACETOTALAMT -- 券面总额
    ,P1.REPOPRINAMT -- 回购本金金额
    ,P1.REPOINTAMT -- 回购到期利息
    ,P1.ALLREPOINTAMT -- 到期本息金额
    ,P1.VDEALAMT -- 首次结算金额
    ,P1.MDEALAMT -- 到期结算金额
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.VCLRFORM END -- 首次结算方式代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.MCLRFORM END -- 到期结算方式代码
    ,P1.ACCOUNT -- 本方账户编号
    ,P1.TRADER -- 本方交易编号
    ,P1.CUSTACCOUNT -- 对手方账户编号
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.CUSTTYPE END -- 对手方类型代码
    ,P1.CUSTTRADER -- 对手方交易员编号
    ,P1.ASSETPS -- 资产流向代码
    ,P1.PRINSETTAMT -- 本金交割金额
    ,P1.INTSETTAMT -- 利息交割金额
    ,P1.INTUNACCAMT -- 利息未计提金额
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.INPUTDATE)) -- 录入日期
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.PAYDAY)) -- 付款日期
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.SETTDATE)) -- 资产交割日期
    ,P1.PAYMARK -- 付款标志
    ,P1.EFFECTFLAG -- 有效标志
    ,P1.FATHERSEQNO -- 父交易编号
    ,P1.ORIGINALSEQNO -- 原交易编号
    ,P1.REFSEQNO -- 转仓流水号
    ,P1.REVSEQNO -- 反向交易流水号
    ,P1.SPLITFLAG -- 拆分交易标志
    ,P1.TRADEMODE -- 资产池标志
    ,P1.MATUREYIELD -- 到期收益率
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.TRADMARKET END -- 交易市场代码
    ,P1.TRADMARKETDESC -- 交易市场描述
    ,P1.VATBREAKEVEN -- 保本标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_rep_deal' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_rep_deal p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BASIS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_REP_DEAL'
        AND R1.SRC_FIELD_EN_NAME= 'BASIS'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_AM_REPO_TRAN'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'INT_ACCR_BASE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.VCLRFORM = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FAMS'
        AND R2.SRC_TAB_EN_NAME= 'FAMS_REP_DEAL'
        AND R2.SRC_FIELD_EN_NAME= 'VCLRFORM'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_AM_REPO_TRAN'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'FIR_STL_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.MCLRFORM = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FAMS'
        AND R3.SRC_TAB_EN_NAME= 'FAMS_REP_DEAL'
        AND R3.SRC_FIELD_EN_NAME= 'MCLRFORM'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_AM_REPO_TRAN'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'EXP_STL_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.CUSTTYPE = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'FAMS'
        AND R5.SRC_TAB_EN_NAME= 'FAMS_REP_DEAL'
        AND R5.SRC_FIELD_EN_NAME= 'CUSTTYPE'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_AM_REPO_TRAN'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'CNTPTY_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.TRADMARKET = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'FAMS'
        AND R4.SRC_TAB_EN_NAME= 'FAMS_REP_DEAL'
        AND R4.SRC_FIELD_EN_NAME= 'TRADMARKET'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_AM_REPO_TRAN'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'TRAN_MARKET_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_am_repo_tran_famsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_am_repo_tran_famsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,bus_id -- 业务编号
    ,onl_flg -- 线上标志
    ,tran_dt -- 交易日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,tenor -- 期限
    ,repo_type_cd -- 回购类型代码
    ,repo_dir_cd -- 回购方向代码
    ,curr_cd -- 币种代码
    ,tran_type_cd -- 交易类型代码
    ,repo_int_rat -- 回购利率
    ,int_accr_base_cd -- 计息基准代码
    ,cert_face_tot -- 券面总额
    ,repo_pric_amt -- 回购本金金额
    ,repo_exp_int -- 回购到期利息
    ,exp_pric_int_amt -- 到期本息金额
    ,fir_stl_amt -- 首次结算金额
    ,exp_stl_amt -- 到期结算金额
    ,fir_stl_way_cd -- 首次结算方式代码
    ,exp_stl_way_cd -- 到期结算方式代码
    ,ghb_acct_id -- 本方账户编号
    ,ghb_tran_id -- 本方交易编号
    ,cntpty_acct_id -- 对手方账户编号
    ,cntpty_type_cd -- 对手方类型代码
    ,cntpty_dealer_id -- 对手方交易员编号
    ,asset_flow_dir_cd -- 资产流向代码
    ,pric_dlvy_amt -- 本金交割金额
    ,int_dlvy_amt -- 利息交割金额
    ,int_not_provi_amt -- 利息未计提金额
    ,input_dt -- 录入日期
    ,pay_dt -- 付款日期
    ,asset_dlvy_dt -- 资产交割日期
    ,pay_flg -- 付款标志
    ,valid_flg -- 有效标志
    ,parent_tran_id -- 父交易编号
    ,init_tran_id -- 原交易编号
    ,trans_flow_num -- 转仓流水号
    ,rev_tran_flow_num -- 反向交易流水号
    ,splt_tran_flg -- 拆分交易标志
    ,asset_pool_flg -- 资产池标志
    ,exp_yld_rat -- 到期收益率
    ,tran_market_cd -- 交易市场代码
    ,tran_market_descb -- 交易市场描述
    ,brkevn_flg -- 保本标志
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 业务编号
    ,nvl(n.onl_flg, o.onl_flg) as onl_flg -- 线上标志
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.tenor, o.tenor) as tenor -- 期限
    ,nvl(n.repo_type_cd, o.repo_type_cd) as repo_type_cd -- 回购类型代码
    ,nvl(n.repo_dir_cd, o.repo_dir_cd) as repo_dir_cd -- 回购方向代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.tran_type_cd, o.tran_type_cd) as tran_type_cd -- 交易类型代码
    ,nvl(n.repo_int_rat, o.repo_int_rat) as repo_int_rat -- 回购利率
    ,nvl(n.int_accr_base_cd, o.int_accr_base_cd) as int_accr_base_cd -- 计息基准代码
    ,nvl(n.cert_face_tot, o.cert_face_tot) as cert_face_tot -- 券面总额
    ,nvl(n.repo_pric_amt, o.repo_pric_amt) as repo_pric_amt -- 回购本金金额
    ,nvl(n.repo_exp_int, o.repo_exp_int) as repo_exp_int -- 回购到期利息
    ,nvl(n.exp_pric_int_amt, o.exp_pric_int_amt) as exp_pric_int_amt -- 到期本息金额
    ,nvl(n.fir_stl_amt, o.fir_stl_amt) as fir_stl_amt -- 首次结算金额
    ,nvl(n.exp_stl_amt, o.exp_stl_amt) as exp_stl_amt -- 到期结算金额
    ,nvl(n.fir_stl_way_cd, o.fir_stl_way_cd) as fir_stl_way_cd -- 首次结算方式代码
    ,nvl(n.exp_stl_way_cd, o.exp_stl_way_cd) as exp_stl_way_cd -- 到期结算方式代码
    ,nvl(n.ghb_acct_id, o.ghb_acct_id) as ghb_acct_id -- 本方账户编号
    ,nvl(n.ghb_tran_id, o.ghb_tran_id) as ghb_tran_id -- 本方交易编号
    ,nvl(n.cntpty_acct_id, o.cntpty_acct_id) as cntpty_acct_id -- 对手方账户编号
    ,nvl(n.cntpty_type_cd, o.cntpty_type_cd) as cntpty_type_cd -- 对手方类型代码
    ,nvl(n.cntpty_dealer_id, o.cntpty_dealer_id) as cntpty_dealer_id -- 对手方交易员编号
    ,nvl(n.asset_flow_dir_cd, o.asset_flow_dir_cd) as asset_flow_dir_cd -- 资产流向代码
    ,nvl(n.pric_dlvy_amt, o.pric_dlvy_amt) as pric_dlvy_amt -- 本金交割金额
    ,nvl(n.int_dlvy_amt, o.int_dlvy_amt) as int_dlvy_amt -- 利息交割金额
    ,nvl(n.int_not_provi_amt, o.int_not_provi_amt) as int_not_provi_amt -- 利息未计提金额
    ,nvl(n.input_dt, o.input_dt) as input_dt -- 录入日期
    ,nvl(n.pay_dt, o.pay_dt) as pay_dt -- 付款日期
    ,nvl(n.asset_dlvy_dt, o.asset_dlvy_dt) as asset_dlvy_dt -- 资产交割日期
    ,nvl(n.pay_flg, o.pay_flg) as pay_flg -- 付款标志
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(n.parent_tran_id, o.parent_tran_id) as parent_tran_id -- 父交易编号
    ,nvl(n.init_tran_id, o.init_tran_id) as init_tran_id -- 原交易编号
    ,nvl(n.trans_flow_num, o.trans_flow_num) as trans_flow_num -- 转仓流水号
    ,nvl(n.rev_tran_flow_num, o.rev_tran_flow_num) as rev_tran_flow_num -- 反向交易流水号
    ,nvl(n.splt_tran_flg, o.splt_tran_flg) as splt_tran_flg -- 拆分交易标志
    ,nvl(n.asset_pool_flg, o.asset_pool_flg) as asset_pool_flg -- 资产池标志
    ,nvl(n.exp_yld_rat, o.exp_yld_rat) as exp_yld_rat -- 到期收益率
    ,nvl(n.tran_market_cd, o.tran_market_cd) as tran_market_cd -- 交易市场代码
    ,nvl(n.tran_market_descb, o.tran_market_descb) as tran_market_descb -- 交易市场描述
    ,nvl(n.brkevn_flg, o.brkevn_flg) as brkevn_flg -- 保本标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.tran_flow_num <> n.tran_flow_num
                or o.bus_id <> n.bus_id
                or o.onl_flg <> n.onl_flg
                or o.tran_dt <> n.tran_dt
                or o.value_dt <> n.value_dt
                or o.exp_dt <> n.exp_dt
                or o.tenor <> n.tenor
                or o.repo_type_cd <> n.repo_type_cd
                or o.repo_dir_cd <> n.repo_dir_cd
                or o.curr_cd <> n.curr_cd
                or o.tran_type_cd <> n.tran_type_cd
                or o.repo_int_rat <> n.repo_int_rat
                or o.int_accr_base_cd <> n.int_accr_base_cd
                or o.cert_face_tot <> n.cert_face_tot
                or o.repo_pric_amt <> n.repo_pric_amt
                or o.repo_exp_int <> n.repo_exp_int
                or o.exp_pric_int_amt <> n.exp_pric_int_amt
                or o.fir_stl_amt <> n.fir_stl_amt
                or o.exp_stl_amt <> n.exp_stl_amt
                or o.fir_stl_way_cd <> n.fir_stl_way_cd
                or o.exp_stl_way_cd <> n.exp_stl_way_cd
                or o.ghb_acct_id <> n.ghb_acct_id
                or o.ghb_tran_id <> n.ghb_tran_id
                or o.cntpty_acct_id <> n.cntpty_acct_id
                or o.cntpty_type_cd <> n.cntpty_type_cd
                or o.cntpty_dealer_id <> n.cntpty_dealer_id
                or o.asset_flow_dir_cd <> n.asset_flow_dir_cd
                or o.pric_dlvy_amt <> n.pric_dlvy_amt
                or o.int_dlvy_amt <> n.int_dlvy_amt
                or o.int_not_provi_amt <> n.int_not_provi_amt
                or o.input_dt <> n.input_dt
                or o.pay_dt <> n.pay_dt
                or o.asset_dlvy_dt <> n.asset_dlvy_dt
                or o.pay_flg <> n.pay_flg
                or o.valid_flg <> n.valid_flg
                or o.parent_tran_id <> n.parent_tran_id
                or o.init_tran_id <> n.init_tran_id
                or o.trans_flow_num <> n.trans_flow_num
                or o.rev_tran_flow_num <> n.rev_tran_flow_num
                or o.splt_tran_flg <> n.splt_tran_flg
                or o.asset_pool_flg <> n.asset_pool_flg
                or o.exp_yld_rat <> n.exp_yld_rat
                or o.tran_market_cd <> n.tran_market_cd
                or o.tran_market_descb <> n.tran_market_descb
                or o.brkevn_flg <> n.brkevn_flg
            ) or (
                 case when (
                           n.agt_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_am_repo_tran_famsf1_tm n
    full join ${iml_schema}.agt_am_repo_tran_famsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_am_repo_tran truncate partition for ('famsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_am_repo_tran exchange subpartition p_famsf1_${batch_date} with table ${iml_schema}.agt_am_repo_tran_famsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_am_repo_tran drop subpartition p_famsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_am_repo_tran to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_am_repo_tran_famsf1_tm purge;
drop table ${iml_schema}.agt_am_repo_tran_famsf1_ex purge;
drop table ${iml_schema}.agt_am_repo_tran_famsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_am_repo_tran', partname => 'p_famsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);