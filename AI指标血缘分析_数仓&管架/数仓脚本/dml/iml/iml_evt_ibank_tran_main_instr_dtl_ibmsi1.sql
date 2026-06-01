/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ibank_tran_main_instr_dtl_ibmsi1
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
alter table ${iml_schema}.evt_ibank_tran_main_instr_dtl add partition p_ibmsi1 values ('ibmsi1')(
        subpartition p_ibmsi1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ibmsi1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_ibank_tran_main_instr_dtl partition for ('ibmsi1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_tm purge;
drop table ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_op purge;
drop table ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,main_instr_seq_num -- 主指令序号
    ,instr_type_cd -- 指令类型代码
    ,parent_fin_instm_market_type_id -- 父金融工具市场类型编号
    ,parent_fin_instm_asset_type_id -- 父金融工具资产类型编号
    ,parent_fin_instm_id -- 父金融工具编号
    ,parent_instr_id -- 父指令编号
    ,intnal_tran_flow_num -- 内部交易流水号
    ,tran_type_cd -- 交易类型代码
    ,stl_way_cd -- 结算方式代码
    ,theory_clear_dt -- 理论清算日期
    ,actl_stl_dt -- 实际结算日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,apv_form_id -- 审批单编号
    ,ext_bag_id -- 外部成交编号
    ,exec_market_id -- 执行市场编号
    ,theory_stl_dt -- 理论结算日期
    ,cap_instr_id -- 资金指令编号
    ,vch_instr_id -- 券指令编号
    ,effect_tm -- 生效时间
    ,mender_name -- 修改人名称
    ,mender_id -- 修改人编号
    ,instr_status_cd -- 指令状态代码
    ,not_price_flg -- 未知价格标志
    ,intnal_cap_acct_id -- 内部资金账户编号
    ,tran_dt -- 交易日期
    ,stl_type_cd -- 结算类型代码
    ,clear_cmplt_flg -- 清算完成标志
    ,surviv_term_instr_flg -- 存续期指令标志
    ,operr_id -- 经办人编号
    ,operr_name -- 经办人名称
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ibank_tran_main_instr_dtl partition for ('ibmsi1')
where 0=1
;

create table ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_ibank_tran_main_instr_dtl partition for ('ibmsi1') where 0=1;

create table ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_ibank_tran_main_instr_dtl partition for ('ibmsi1') where 0=1;

-- 3.1 get new data into table
-- ibms_ttrd_set_instruction-1
insert into ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,main_instr_seq_num -- 主指令序号
    ,instr_type_cd -- 指令类型代码
    ,parent_fin_instm_market_type_id -- 父金融工具市场类型编号
    ,parent_fin_instm_asset_type_id -- 父金融工具资产类型编号
    ,parent_fin_instm_id -- 父金融工具编号
    ,parent_instr_id -- 父指令编号
    ,intnal_tran_flow_num -- 内部交易流水号
    ,tran_type_cd -- 交易类型代码
    ,stl_way_cd -- 结算方式代码
    ,theory_clear_dt -- 理论清算日期
    ,actl_stl_dt -- 实际结算日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,apv_form_id -- 审批单编号
    ,ext_bag_id -- 外部成交编号
    ,exec_market_id -- 执行市场编号
    ,theory_stl_dt -- 理论结算日期
    ,cap_instr_id -- 资金指令编号
    ,vch_instr_id -- 券指令编号
    ,effect_tm -- 生效时间
    ,mender_name -- 修改人名称
    ,mender_id -- 修改人编号
    ,instr_status_cd -- 指令状态代码
    ,not_price_flg -- 未知价格标志
    ,intnal_cap_acct_id -- 内部资金账户编号
    ,tran_dt -- 交易日期
    ,stl_type_cd -- 结算类型代码
    ,clear_cmplt_flg -- 清算完成标志
    ,surviv_term_instr_flg -- 存续期指令标志
    ,operr_id -- 经办人编号
    ,operr_name -- 经办人名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '105002'||TO_CHAR(P1.INST_ID) -- 事件编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.INST_ID) -- 主指令序号
    ,NVL(TRIM(TO_CHAR(P1.INST_TYPE)),'-') -- 指令类型代码
    ,P1.H_M_TYPE -- 父金融工具市场类型编号
    ,P1.H_A_TYPE -- 父金融工具资产类型编号
    ,P1.H_I_CODE -- 父金融工具编号
    ,TO_CHAR(P1.INST_GRP_ID) -- 父指令编号
    ,P1.TRADE_ID -- 内部交易流水号
    ,P1.TRD_TYPE -- 交易类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.SET_TYPE END -- 结算方式代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.THEORY_SET_DATE) -- 理论清算日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.REAL_SET_DATE) -- 实际结算日期
    ,TO_CHAR(P1.PARTY_ID) -- 交易对手编号
    ,P1.PARTY_NAME -- 交易对手名称
    ,P1.ORDER_ID -- 审批单编号
    ,P1.EXT_ORD_ID -- 外部成交编号
    ,P1.EXE_MARKET -- 执行市场编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.CAL_DATE) -- 理论结算日期
    ,TO_CHAR(P1.REF_CASH_INST_ID) -- 资金指令编号
    ,TO_CHAR(P1.REF_SECU_INST_ID) -- 券指令编号
    ,${iml_schema}.TIMEFORMAT_MIN(P1.UPDATE_TIME) -- 生效时间
    ,P1.UPDATE_USER -- 修改人名称
    ,P1.UPDATE_USER_ID -- 修改人编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||TO_CHAR(P1.STATE) END -- 指令状态代码
    ,NVL(TRIM(P1.IS_UNKNOWN_PRICE),'-') -- 未知价格标志
    ,P1.CASH_ACCT_ID -- 内部资金账户编号
    ,${iml_schema}.DATEFORMAT_MAX2(P1.ORDDATE) -- 交易日期
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.SETTLEMODE END -- 结算类型代码
    ,NVL(TRIM(P1.CLEARING_COMPLETED),'-') -- 清算完成标志
    ,NVL(TRIM(P1.IS_PERIOD_INST),'-') -- 存续期指令标志
    ,P1.OPERATOR_ID -- 经办人编号
    ,P1.OPERATOR_NAME -- 经办人名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_set_instruction' -- 源表名称
    ,'ibmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_set_instruction p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.SET_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IBMS'
        AND R1.SRC_TAB_EN_NAME= 'IBMS_TTRD_SET_INSTRUCTION'
        AND R1.SRC_FIELD_EN_NAME= 'SET_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_IBANK_TRAN_MAIN_INSTR_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'STL_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on TO_CHAR(P1.STATE) = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IBMS'
        AND R2.SRC_TAB_EN_NAME= 'IBMS_TTRD_SET_INSTRUCTION'
        AND R2.SRC_FIELD_EN_NAME= 'STATE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_IBANK_TRAN_MAIN_INSTR_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'INSTR_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.SETTLEMODE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IBMS'
        AND R3.SRC_TAB_EN_NAME= 'IBMS_TTRD_SET_INSTRUCTION'
        AND R3.SRC_FIELD_EN_NAME= 'SETTLEMODE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_IBANK_TRAN_MAIN_INSTR_DTL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'STL_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
        and not exists (select 1 
                      from iol.ibms_ttrd_set_instruction_his t1
                     where p1.INST_ID = t1.INST_ID)
;
commit;

-- ibms_ttrd_set_instruction_his-1
insert into ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,main_instr_seq_num -- 主指令序号
    ,instr_type_cd -- 指令类型代码
    ,parent_fin_instm_market_type_id -- 父金融工具市场类型编号
    ,parent_fin_instm_asset_type_id -- 父金融工具资产类型编号
    ,parent_fin_instm_id -- 父金融工具编号
    ,parent_instr_id -- 父指令编号
    ,intnal_tran_flow_num -- 内部交易流水号
    ,tran_type_cd -- 交易类型代码
    ,stl_way_cd -- 结算方式代码
    ,theory_clear_dt -- 理论清算日期
    ,actl_stl_dt -- 实际结算日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,apv_form_id -- 审批单编号
    ,ext_bag_id -- 外部成交编号
    ,exec_market_id -- 执行市场编号
    ,theory_stl_dt -- 理论结算日期
    ,cap_instr_id -- 资金指令编号
    ,vch_instr_id -- 券指令编号
    ,effect_tm -- 生效时间
    ,mender_name -- 修改人名称
    ,mender_id -- 修改人编号
    ,instr_status_cd -- 指令状态代码
    ,not_price_flg -- 未知价格标志
    ,intnal_cap_acct_id -- 内部资金账户编号
    ,tran_dt -- 交易日期
    ,stl_type_cd -- 结算类型代码
    ,clear_cmplt_flg -- 清算完成标志
    ,surviv_term_instr_flg -- 存续期指令标志
    ,operr_id -- 经办人编号
    ,operr_name -- 经办人名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '105002'||TO_CHAR(P1.INST_ID) -- 事件编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.INST_ID) -- 主指令序号
    ,NVL(TRIM(TO_CHAR(P1.INST_TYPE)),'-') -- 指令类型代码
    ,P1.H_M_TYPE -- 父金融工具市场类型编号
    ,P1.H_A_TYPE -- 父金融工具资产类型编号
    ,P1.H_I_CODE -- 父金融工具编号
    ,TO_CHAR(P1.INST_GRP_ID) -- 父指令编号
    ,P1.TRADE_ID -- 内部交易流水号
    ,P1.TRD_TYPE -- 交易类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.SET_TYPE END -- 结算方式代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.THEORY_SET_DATE) -- 理论清算日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.REAL_SET_DATE) -- 实际结算日期
    ,TO_CHAR(P1.PARTY_ID) -- 交易对手编号
    ,P1.PARTY_NAME -- 交易对手名称
    ,P1.ORDER_ID -- 审批单编号
    ,P1.EXT_ORD_ID -- 外部成交编号
    ,P1.EXE_MARKET -- 执行市场编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.CAL_DATE) -- 理论结算日期
    ,TO_CHAR(P1.REF_CASH_INST_ID) -- 资金指令编号
    ,TO_CHAR(P1.REF_SECU_INST_ID) -- 券指令编号
    ,${iml_schema}.TIMEFORMAT_MIN(P1.UPDATE_TIME) -- 生效时间
    ,P1.UPDATE_USER -- 修改人名称
    ,P1.UPDATE_USER_ID -- 修改人编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||TO_CHAR(P1.STATE) END -- 指令状态代码
    ,NVL(TRIM(P1.IS_UNKNOWN_PRICE),'-') -- 未知价格标志
    ,P1.CASH_ACCT_ID -- 内部资金账户编号
    ,${iml_schema}.DATEFORMAT_MAX2(P1.ORDDATE) -- 交易日期
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.SETTLEMODE END -- 结算类型代码
    ,NVL(TRIM(P1.CLEARING_COMPLETED),'-') -- 清算完成标志
    ,NVL(TRIM(P1.IS_PERIOD_INST),'-') -- 存续期指令标志
    ,P1.OPERATOR_ID -- 经办人编号
    ,P1.OPERATOR_NAME -- 经办人名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_set_instruction_his' -- 源表名称
    ,'ibmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_set_instruction_his p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.SET_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IBMS'
        AND R1.SRC_TAB_EN_NAME= 'IBMS_TTRD_SET_INSTRUCTION_HIS'
        AND R1.SRC_FIELD_EN_NAME= 'SET_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_IBANK_TRAN_MAIN_INSTR_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'STL_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on TO_CHAR(P1.STATE) = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IBMS'
        AND R2.SRC_TAB_EN_NAME= 'IBMS_TTRD_SET_INSTRUCTION_HIS'
        AND R2.SRC_FIELD_EN_NAME= 'STATE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_IBANK_TRAN_MAIN_INSTR_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'INSTR_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.SETTLEMODE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IBMS'
        AND R3.SRC_TAB_EN_NAME= 'IBMS_TTRD_SET_INSTRUCTION_HIS'
        AND R3.SRC_FIELD_EN_NAME= 'SETTLEMODE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_IBANK_TRAN_MAIN_INSTR_DTL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'STL_TYPE_CD'
where  1 = 1 
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_tm 
  	                                group by 
  	                                        evt_id
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,main_instr_seq_num -- 主指令序号
    ,instr_type_cd -- 指令类型代码
    ,parent_fin_instm_market_type_id -- 父金融工具市场类型编号
    ,parent_fin_instm_asset_type_id -- 父金融工具资产类型编号
    ,parent_fin_instm_id -- 父金融工具编号
    ,parent_instr_id -- 父指令编号
    ,intnal_tran_flow_num -- 内部交易流水号
    ,tran_type_cd -- 交易类型代码
    ,stl_way_cd -- 结算方式代码
    ,theory_clear_dt -- 理论清算日期
    ,actl_stl_dt -- 实际结算日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,apv_form_id -- 审批单编号
    ,ext_bag_id -- 外部成交编号
    ,exec_market_id -- 执行市场编号
    ,theory_stl_dt -- 理论结算日期
    ,cap_instr_id -- 资金指令编号
    ,vch_instr_id -- 券指令编号
    ,effect_tm -- 生效时间
    ,mender_name -- 修改人名称
    ,mender_id -- 修改人编号
    ,instr_status_cd -- 指令状态代码
    ,not_price_flg -- 未知价格标志
    ,intnal_cap_acct_id -- 内部资金账户编号
    ,tran_dt -- 交易日期
    ,stl_type_cd -- 结算类型代码
    ,clear_cmplt_flg -- 清算完成标志
    ,surviv_term_instr_flg -- 存续期指令标志
    ,operr_id -- 经办人编号
    ,operr_name -- 经办人名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,main_instr_seq_num -- 主指令序号
    ,instr_type_cd -- 指令类型代码
    ,parent_fin_instm_market_type_id -- 父金融工具市场类型编号
    ,parent_fin_instm_asset_type_id -- 父金融工具资产类型编号
    ,parent_fin_instm_id -- 父金融工具编号
    ,parent_instr_id -- 父指令编号
    ,intnal_tran_flow_num -- 内部交易流水号
    ,tran_type_cd -- 交易类型代码
    ,stl_way_cd -- 结算方式代码
    ,theory_clear_dt -- 理论清算日期
    ,actl_stl_dt -- 实际结算日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,apv_form_id -- 审批单编号
    ,ext_bag_id -- 外部成交编号
    ,exec_market_id -- 执行市场编号
    ,theory_stl_dt -- 理论结算日期
    ,cap_instr_id -- 资金指令编号
    ,vch_instr_id -- 券指令编号
    ,effect_tm -- 生效时间
    ,mender_name -- 修改人名称
    ,mender_id -- 修改人编号
    ,instr_status_cd -- 指令状态代码
    ,not_price_flg -- 未知价格标志
    ,intnal_cap_acct_id -- 内部资金账户编号
    ,tran_dt -- 交易日期
    ,stl_type_cd -- 结算类型代码
    ,clear_cmplt_flg -- 清算完成标志
    ,surviv_term_instr_flg -- 存续期指令标志
    ,operr_id -- 经办人编号
    ,operr_name -- 经办人名称
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
    ,nvl(n.main_instr_seq_num, o.main_instr_seq_num) as main_instr_seq_num -- 主指令序号
    ,nvl(n.instr_type_cd, o.instr_type_cd) as instr_type_cd -- 指令类型代码
    ,nvl(n.parent_fin_instm_market_type_id, o.parent_fin_instm_market_type_id) as parent_fin_instm_market_type_id -- 父金融工具市场类型编号
    ,nvl(n.parent_fin_instm_asset_type_id, o.parent_fin_instm_asset_type_id) as parent_fin_instm_asset_type_id -- 父金融工具资产类型编号
    ,nvl(n.parent_fin_instm_id, o.parent_fin_instm_id) as parent_fin_instm_id -- 父金融工具编号
    ,nvl(n.parent_instr_id, o.parent_instr_id) as parent_instr_id -- 父指令编号
    ,nvl(n.intnal_tran_flow_num, o.intnal_tran_flow_num) as intnal_tran_flow_num -- 内部交易流水号
    ,nvl(n.tran_type_cd, o.tran_type_cd) as tran_type_cd -- 交易类型代码
    ,nvl(n.stl_way_cd, o.stl_way_cd) as stl_way_cd -- 结算方式代码
    ,nvl(n.theory_clear_dt, o.theory_clear_dt) as theory_clear_dt -- 理论清算日期
    ,nvl(n.actl_stl_dt, o.actl_stl_dt) as actl_stl_dt -- 实际结算日期
    ,nvl(n.cntpty_id, o.cntpty_id) as cntpty_id -- 交易对手编号
    ,nvl(n.cntpty_name, o.cntpty_name) as cntpty_name -- 交易对手名称
    ,nvl(n.apv_form_id, o.apv_form_id) as apv_form_id -- 审批单编号
    ,nvl(n.ext_bag_id, o.ext_bag_id) as ext_bag_id -- 外部成交编号
    ,nvl(n.exec_market_id, o.exec_market_id) as exec_market_id -- 执行市场编号
    ,nvl(n.theory_stl_dt, o.theory_stl_dt) as theory_stl_dt -- 理论结算日期
    ,nvl(n.cap_instr_id, o.cap_instr_id) as cap_instr_id -- 资金指令编号
    ,nvl(n.vch_instr_id, o.vch_instr_id) as vch_instr_id -- 券指令编号
    ,nvl(n.effect_tm, o.effect_tm) as effect_tm -- 生效时间
    ,nvl(n.mender_name, o.mender_name) as mender_name -- 修改人名称
    ,nvl(n.mender_id, o.mender_id) as mender_id -- 修改人编号
    ,nvl(n.instr_status_cd, o.instr_status_cd) as instr_status_cd -- 指令状态代码
    ,nvl(n.not_price_flg, o.not_price_flg) as not_price_flg -- 未知价格标志
    ,nvl(n.intnal_cap_acct_id, o.intnal_cap_acct_id) as intnal_cap_acct_id -- 内部资金账户编号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.stl_type_cd, o.stl_type_cd) as stl_type_cd -- 结算类型代码
    ,nvl(n.clear_cmplt_flg, o.clear_cmplt_flg) as clear_cmplt_flg -- 清算完成标志
    ,nvl(n.surviv_term_instr_flg, o.surviv_term_instr_flg) as surviv_term_instr_flg -- 存续期指令标志
    ,nvl(n.operr_id, o.operr_id) as operr_id -- 经办人编号
    ,nvl(n.operr_name, o.operr_name) as operr_name -- 经办人名称
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_tm n
    full join (select * from ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
    )
    or (
        o.main_instr_seq_num <> n.main_instr_seq_num
        or o.instr_type_cd <> n.instr_type_cd
        or o.parent_fin_instm_market_type_id <> n.parent_fin_instm_market_type_id
        or o.parent_fin_instm_asset_type_id <> n.parent_fin_instm_asset_type_id
        or o.parent_fin_instm_id <> n.parent_fin_instm_id
        or o.parent_instr_id <> n.parent_instr_id
        or o.intnal_tran_flow_num <> n.intnal_tran_flow_num
        or o.tran_type_cd <> n.tran_type_cd
        or o.stl_way_cd <> n.stl_way_cd
        or o.theory_clear_dt <> n.theory_clear_dt
        or o.actl_stl_dt <> n.actl_stl_dt
        or o.cntpty_id <> n.cntpty_id
        or o.cntpty_name <> n.cntpty_name
        or o.apv_form_id <> n.apv_form_id
        or o.ext_bag_id <> n.ext_bag_id
        or o.exec_market_id <> n.exec_market_id
        or o.theory_stl_dt <> n.theory_stl_dt
        or o.cap_instr_id <> n.cap_instr_id
        or o.vch_instr_id <> n.vch_instr_id
        or o.effect_tm <> n.effect_tm
        or o.mender_name <> n.mender_name
        or o.mender_id <> n.mender_id
        or o.instr_status_cd <> n.instr_status_cd
        or o.not_price_flg <> n.not_price_flg
        or o.intnal_cap_acct_id <> n.intnal_cap_acct_id
        or o.tran_dt <> n.tran_dt
        or o.stl_type_cd <> n.stl_type_cd
        or o.clear_cmplt_flg <> n.clear_cmplt_flg
        or o.surviv_term_instr_flg <> n.surviv_term_instr_flg
        or o.operr_id <> n.operr_id
        or o.operr_name <> n.operr_name
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,main_instr_seq_num -- 主指令序号
    ,instr_type_cd -- 指令类型代码
    ,parent_fin_instm_market_type_id -- 父金融工具市场类型编号
    ,parent_fin_instm_asset_type_id -- 父金融工具资产类型编号
    ,parent_fin_instm_id -- 父金融工具编号
    ,parent_instr_id -- 父指令编号
    ,intnal_tran_flow_num -- 内部交易流水号
    ,tran_type_cd -- 交易类型代码
    ,stl_way_cd -- 结算方式代码
    ,theory_clear_dt -- 理论清算日期
    ,actl_stl_dt -- 实际结算日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,apv_form_id -- 审批单编号
    ,ext_bag_id -- 外部成交编号
    ,exec_market_id -- 执行市场编号
    ,theory_stl_dt -- 理论结算日期
    ,cap_instr_id -- 资金指令编号
    ,vch_instr_id -- 券指令编号
    ,effect_tm -- 生效时间
    ,mender_name -- 修改人名称
    ,mender_id -- 修改人编号
    ,instr_status_cd -- 指令状态代码
    ,not_price_flg -- 未知价格标志
    ,intnal_cap_acct_id -- 内部资金账户编号
    ,tran_dt -- 交易日期
    ,stl_type_cd -- 结算类型代码
    ,clear_cmplt_flg -- 清算完成标志
    ,surviv_term_instr_flg -- 存续期指令标志
    ,operr_id -- 经办人编号
    ,operr_name -- 经办人名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,main_instr_seq_num -- 主指令序号
    ,instr_type_cd -- 指令类型代码
    ,parent_fin_instm_market_type_id -- 父金融工具市场类型编号
    ,parent_fin_instm_asset_type_id -- 父金融工具资产类型编号
    ,parent_fin_instm_id -- 父金融工具编号
    ,parent_instr_id -- 父指令编号
    ,intnal_tran_flow_num -- 内部交易流水号
    ,tran_type_cd -- 交易类型代码
    ,stl_way_cd -- 结算方式代码
    ,theory_clear_dt -- 理论清算日期
    ,actl_stl_dt -- 实际结算日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,apv_form_id -- 审批单编号
    ,ext_bag_id -- 外部成交编号
    ,exec_market_id -- 执行市场编号
    ,theory_stl_dt -- 理论结算日期
    ,cap_instr_id -- 资金指令编号
    ,vch_instr_id -- 券指令编号
    ,effect_tm -- 生效时间
    ,mender_name -- 修改人名称
    ,mender_id -- 修改人编号
    ,instr_status_cd -- 指令状态代码
    ,not_price_flg -- 未知价格标志
    ,intnal_cap_acct_id -- 内部资金账户编号
    ,tran_dt -- 交易日期
    ,stl_type_cd -- 结算类型代码
    ,clear_cmplt_flg -- 清算完成标志
    ,surviv_term_instr_flg -- 存续期指令标志
    ,operr_id -- 经办人编号
    ,operr_name -- 经办人名称
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
    ,o.main_instr_seq_num -- 主指令序号
    ,o.instr_type_cd -- 指令类型代码
    ,o.parent_fin_instm_market_type_id -- 父金融工具市场类型编号
    ,o.parent_fin_instm_asset_type_id -- 父金融工具资产类型编号
    ,o.parent_fin_instm_id -- 父金融工具编号
    ,o.parent_instr_id -- 父指令编号
    ,o.intnal_tran_flow_num -- 内部交易流水号
    ,o.tran_type_cd -- 交易类型代码
    ,o.stl_way_cd -- 结算方式代码
    ,o.theory_clear_dt -- 理论清算日期
    ,o.actl_stl_dt -- 实际结算日期
    ,o.cntpty_id -- 交易对手编号
    ,o.cntpty_name -- 交易对手名称
    ,o.apv_form_id -- 审批单编号
    ,o.ext_bag_id -- 外部成交编号
    ,o.exec_market_id -- 执行市场编号
    ,o.theory_stl_dt -- 理论结算日期
    ,o.cap_instr_id -- 资金指令编号
    ,o.vch_instr_id -- 券指令编号
    ,o.effect_tm -- 生效时间
    ,o.mender_name -- 修改人名称
    ,o.mender_id -- 修改人编号
    ,o.instr_status_cd -- 指令状态代码
    ,o.not_price_flg -- 未知价格标志
    ,o.intnal_cap_acct_id -- 内部资金账户编号
    ,o.tran_dt -- 交易日期
    ,o.stl_type_cd -- 结算类型代码
    ,o.clear_cmplt_flg -- 清算完成标志
    ,o.surviv_term_instr_flg -- 存续期指令标志
    ,o.operr_id -- 经办人编号
    ,o.operr_name -- 经办人名称
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
from ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_bk o
    left join ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_ibank_tran_main_instr_dtl;
--alter table ${iml_schema}.evt_ibank_tran_main_instr_dtl truncate partition for ('ibmsi1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_ibank_tran_main_instr_dtl') 
               and substr(subpartition_name,1,8)=upper('p_ibmsi1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_ibank_tran_main_instr_dtl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_ibank_tran_main_instr_dtl modify partition p_ibmsi1 
add subpartition p_ibmsi1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_ibank_tran_main_instr_dtl exchange subpartition p_ibmsi1_${batch_date} with table ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_cl;
alter table ${iml_schema}.evt_ibank_tran_main_instr_dtl exchange subpartition p_ibmsi1_20991231 with table ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ibank_tran_main_instr_dtl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_tm purge;
drop table ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_op purge;
drop table ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_ibank_tran_main_instr_dtl_ibmsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ibank_tran_main_instr_dtl', partname => 'p_ibmsi1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
