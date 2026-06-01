/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ibank_tran_vch_instr_dtl_ibmsi1
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
alter table ${iml_schema}.evt_ibank_tran_vch_instr_dtl add partition p_ibmsi1 values ('ibmsi1')(
        subpartition p_ibmsi1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ibmsi1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_ibank_tran_vch_instr_dtl partition for ('ibmsi1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_tm purge;
drop table ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_op purge;
drop table ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,secu_instr_seq_num -- 券指令序号
    ,main_instr_seq_num -- 主指令序号
    ,ext_vch_acct_id -- 外部券账户编号
    ,intnal_vch_acct_id -- 内部券账户编号
    ,fin_instm_id -- 金融工具编号
    ,fin_instm_name -- 金融工具名称
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,merge_acpt_pay_id -- 合并收付编号
    ,cap_flow_dir_cd -- 资金流向代码
    ,curr_cd -- 币种代码
    ,fee_cost_chg -- 费用成本变动
    ,acru_int_cost_chg -- 应计利息成本变动
    ,actl_acru_int -- 实际应计利息
    ,actl_net_price_amt -- 实际净价金额
    ,recvbl_uncol_int -- 应收未收利息
    ,recvbl_uncol_pric -- 应收未收本金
    ,pl_fee -- 损益费用
    ,int_recvbl_resv_flg -- 应收利息保留标志
    ,recvbl_pric_resv_flg -- 应收本金保留标志
    ,bal_qtty_chg -- 余额数量变动
    ,froz_qtty -- 冻结数量
    ,calc_closing_dt -- 计算截止日期
    ,stl_dt -- 结算日期
    ,actl_stl_dt -- 实际结算日期
    ,prod_cls_name -- 产品分类名称
    ,full_price_cost_chg -- 全价成本变动
    ,ghb_zzd_trust_acct_num -- 本方中债登托管账号
    ,cntpty_zzd_trust_acct_num -- 对手中债登托管账号
    ,effect_tm -- 生效时间
    ,stl_denom -- 结算面额
    ,accti_tran_flow_num -- 核算交易流水号
    ,theory_fee -- 理论费用
    ,fee_cost -- 费用成本
    ,accti_impam_obj_flg -- 核算减值对象标志
    ,start_int_accr_dt -- 开始计息日期
    ,expect_qtty -- 预计数量
    ,expect_denom -- 预计面额
    ,operr_name -- 经办人名称
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ibank_tran_vch_instr_dtl partition for ('ibmsi1')
where 0=1
;

create table ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_ibank_tran_vch_instr_dtl partition for ('ibmsi1') where 0=1;

create table ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_ibank_tran_vch_instr_dtl partition for ('ibmsi1') where 0=1;

-- 3.1 get new data into table
-- ibms_ttrd_set_instruction_secu-1
insert into ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,secu_instr_seq_num -- 券指令序号
    ,main_instr_seq_num -- 主指令序号
    ,ext_vch_acct_id -- 外部券账户编号
    ,intnal_vch_acct_id -- 内部券账户编号
    ,fin_instm_id -- 金融工具编号
    ,fin_instm_name -- 金融工具名称
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,merge_acpt_pay_id -- 合并收付编号
    ,cap_flow_dir_cd -- 资金流向代码
    ,curr_cd -- 币种代码
    ,fee_cost_chg -- 费用成本变动
    ,acru_int_cost_chg -- 应计利息成本变动
    ,actl_acru_int -- 实际应计利息
    ,actl_net_price_amt -- 实际净价金额
    ,recvbl_uncol_int -- 应收未收利息
    ,recvbl_uncol_pric -- 应收未收本金
    ,pl_fee -- 损益费用
    ,int_recvbl_resv_flg -- 应收利息保留标志
    ,recvbl_pric_resv_flg -- 应收本金保留标志
    ,bal_qtty_chg -- 余额数量变动
    ,froz_qtty -- 冻结数量
    ,calc_closing_dt -- 计算截止日期
    ,stl_dt -- 结算日期
    ,actl_stl_dt -- 实际结算日期
    ,prod_cls_name -- 产品分类名称
    ,full_price_cost_chg -- 全价成本变动
    ,ghb_zzd_trust_acct_num -- 本方中债登托管账号
    ,cntpty_zzd_trust_acct_num -- 对手中债登托管账号
    ,effect_tm -- 生效时间
    ,stl_denom -- 结算面额
    ,accti_tran_flow_num -- 核算交易流水号
    ,theory_fee -- 理论费用
    ,fee_cost -- 费用成本
    ,accti_impam_obj_flg -- 核算减值对象标志
    ,start_int_accr_dt -- 开始计息日期
    ,expect_qtty -- 预计数量
    ,expect_denom -- 预计面额
    ,operr_name -- 经办人名称
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '105003'||TO_CHAR(P1.SECU_INST_ID) -- 事件编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.SECU_INST_ID) -- 券指令序号
    ,TO_CHAR(P1.INST_ID) -- 主指令序号
    ,P1.SECU_ACCT_ID -- 外部券账户编号
    ,P1.EXT_SECU_ACCT_ID -- 内部券账户编号
    ,P1.I_CODE -- 金融工具编号
    ,P1.I_NAME -- 金融工具名称
    ,P1.A_TYPE -- 资产类型编号
    ,P1.M_TYPE -- 市场类型编号
    ,to_char(P1.SECU_INST_SETGRP_ID) -- 合并收付编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DIRECTION END -- 资金流向代码
    ,NVL(TRIM(P1.CURRENCY),'-') -- 币种代码
    ,P1.REAL_FEE -- 费用成本变动
    ,P1.ESTD_AI -- 应计利息成本变动
    ,P1.REAL_AI -- 实际应计利息
    ,P1.REAL_CP -- 实际净价金额
    ,P1.DUE_AI -- 应收未收利息
    ,P1.DUE_CP -- 应收未收本金
    ,P1.PRFT_FEE -- 损益费用
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||TO_CHAR(P1.IS_REMAIN_DUE_AI) END -- 应收利息保留标志
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||TO_CHAR(P1.IS_REMAIN_DUE_CP) END -- 应收本金保留标志
    ,P1.VOLUME -- 余额数量变动
    ,P1.FREEZE_VOLUME -- 冻结数量
    ,${iml_schema}.DATEFORMAT_MAX2(P1.CAL_DATE) -- 计算截止日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.SET_DATE) -- 结算日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.SET_FINISH_DATE) -- 实际结算日期
    ,P1.P_CLASS -- 产品分类名称
    ,P1.COST -- 全价成本变动
    ,P1.ZZD_ACCT_CODE -- 本方中债登托管账号
    ,P1.PARTY_ZZD_ACCT_CODE -- 对手中债登托管账号
    ,${iml_schema}.TIMEFORMAT_MIN(substr(P1.UPDATE_TIME,1,19)) -- 生效时间
    ,P1.AMOUNT -- 结算面额
    ,P1.CLOSE_TRADE_ID -- 核算交易流水号
    ,P1.ESTD_FEE -- 理论费用
    ,P1.FEE -- 费用成本
    ,NVL(TRIM(P1.IS_IMPAIR),'-') -- 核算减值对象标志
    ,${iml_schema}.DATEFORMAT_MIN(P1.CAL_START_DATE) -- 开始计息日期
    ,P1.ESTD_VOLUME -- 预计数量
    ,P1.ESTD_AMOUNT -- 预计面额
    ,P1.UPDATE_USER -- 经办人名称
    ,P1.MEMO -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_set_instruction_secu' -- 源表名称
    ,'ibmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_set_instruction_secu p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DIRECTION = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IBMS'
        AND R1.SRC_TAB_EN_NAME= 'IBMS_TTRD_SET_INSTRUCTION_SECU'
        AND R1.SRC_FIELD_EN_NAME= 'DIRECTION'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_IBANK_TRAN_VCH_INSTR_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CAP_FLOW_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on TO_CHAR(P1.IS_REMAIN_DUE_AI) = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IBMS'
        AND R2.SRC_TAB_EN_NAME= 'IBMS_TTRD_SET_INSTRUCTION_SECU'
        AND R2.SRC_FIELD_EN_NAME= 'IS_REMAIN_DUE_AI'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_IBANK_TRAN_VCH_INSTR_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'INT_RECVBL_RESV_FLG'
    left join ${iml_schema}.ref_pub_cd_map r3 on TO_CHAR(P1.IS_REMAIN_DUE_CP) = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IBMS'
        AND R3.SRC_TAB_EN_NAME= 'IBMS_TTRD_SET_INSTRUCTION_SECU'
        AND R3.SRC_FIELD_EN_NAME= 'IS_REMAIN_DUE_CP'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_IBANK_TRAN_VCH_INSTR_DTL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'RECVBL_PRIC_RESV_FLG'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
        and not exists (select 1 
                      from iol.ibms_ttrd_set_instruction_secu_his t1
                     where p1.SECU_INST_ID = t1.SECU_INST_ID)
;
commit;

-- ibms_ttrd_set_instruction_secu_his-1
insert into ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,secu_instr_seq_num -- 券指令序号
    ,main_instr_seq_num -- 主指令序号
    ,ext_vch_acct_id -- 外部券账户编号
    ,intnal_vch_acct_id -- 内部券账户编号
    ,fin_instm_id -- 金融工具编号
    ,fin_instm_name -- 金融工具名称
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,merge_acpt_pay_id -- 合并收付编号
    ,cap_flow_dir_cd -- 资金流向代码
    ,curr_cd -- 币种代码
    ,fee_cost_chg -- 费用成本变动
    ,acru_int_cost_chg -- 应计利息成本变动
    ,actl_acru_int -- 实际应计利息
    ,actl_net_price_amt -- 实际净价金额
    ,recvbl_uncol_int -- 应收未收利息
    ,recvbl_uncol_pric -- 应收未收本金
    ,pl_fee -- 损益费用
    ,int_recvbl_resv_flg -- 应收利息保留标志
    ,recvbl_pric_resv_flg -- 应收本金保留标志
    ,bal_qtty_chg -- 余额数量变动
    ,froz_qtty -- 冻结数量
    ,calc_closing_dt -- 计算截止日期
    ,stl_dt -- 结算日期
    ,actl_stl_dt -- 实际结算日期
    ,prod_cls_name -- 产品分类名称
    ,full_price_cost_chg -- 全价成本变动
    ,ghb_zzd_trust_acct_num -- 本方中债登托管账号
    ,cntpty_zzd_trust_acct_num -- 对手中债登托管账号
    ,effect_tm -- 生效时间
    ,stl_denom -- 结算面额
    ,accti_tran_flow_num -- 核算交易流水号
    ,theory_fee -- 理论费用
    ,fee_cost -- 费用成本
    ,accti_impam_obj_flg -- 核算减值对象标志
    ,start_int_accr_dt -- 开始计息日期
    ,expect_qtty -- 预计数量
    ,expect_denom -- 预计面额
    ,operr_name -- 经办人名称
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '105003'||TO_CHAR(P1.SECU_INST_ID) -- 事件编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.SECU_INST_ID) -- 券指令序号
    ,TO_CHAR(P1.INST_ID) -- 主指令序号
    ,P1.SECU_ACCT_ID -- 外部券账户编号
    ,P1.EXT_SECU_ACCT_ID -- 内部券账户编号
    ,P1.I_CODE -- 金融工具编号
    ,P1.I_NAME -- 金融工具名称
    ,P1.A_TYPE -- 资产类型编号
    ,P1.M_TYPE -- 市场类型编号
    ,to_char(P1.SECU_INST_SETGRP_ID) -- 合并收付编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DIRECTION END -- 资金流向代码
    ,NVL(TRIM(P1.CURRENCY),'-') -- 币种代码
    ,P1.REAL_FEE -- 费用成本变动
    ,P1.ESTD_AI -- 应计利息成本变动
    ,P1.REAL_AI -- 实际应计利息
    ,P1.REAL_CP -- 实际净价金额
    ,P1.DUE_AI -- 应收未收利息
    ,P1.DUE_CP -- 应收未收本金
    ,P1.PRFT_FEE -- 损益费用
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||TO_CHAR(P1.IS_REMAIN_DUE_AI) END -- 应收利息保留标志
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||TO_CHAR(P1.IS_REMAIN_DUE_CP) END -- 应收本金保留标志
    ,P1.VOLUME -- 余额数量变动
    ,P1.FREEZE_VOLUME -- 冻结数量
    ,${iml_schema}.DATEFORMAT_MAX2(P1.CAL_DATE) -- 计算截止日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.SET_DATE) -- 结算日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.SET_FINISH_DATE) -- 实际结算日期
    ,P1.P_CLASS -- 产品分类名称
    ,P1.COST -- 全价成本变动
    ,P1.ZZD_ACCT_CODE -- 本方中债登托管账号
    ,P1.PARTY_ZZD_ACCT_CODE -- 对手中债登托管账号
    ,${iml_schema}.TIMEFORMAT_MIN(P1.UPDATE_TIME) -- 生效时间
    ,P1.AMOUNT -- 结算面额
    ,P1.CLOSE_TRADE_ID -- 核算交易流水号
    ,P1.ESTD_FEE -- 理论费用
    ,P1.FEE -- 费用成本
    ,NVL(TRIM(P1.IS_IMPAIR),'-') -- 核算减值对象标志
    ,${iml_schema}.DATEFORMAT_MIN(P1.CAL_START_DATE) -- 开始计息日期
    ,P1.ESTD_VOLUME -- 预计数量
    ,P1.ESTD_AMOUNT -- 预计面额
    ,P1.UPDATE_USER -- 经办人名称
    ,P1.MEMO -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_set_instruction_secu_his' -- 源表名称
    ,'ibmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_set_instruction_secu_his p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DIRECTION = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IBMS'
        AND R1.SRC_TAB_EN_NAME= 'IBMS_TTRD_SET_INSTRUCTION_SECU_HIS'
        AND R1.SRC_FIELD_EN_NAME= 'DIRECTION'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_IBANK_TRAN_VCH_INSTR_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CAP_FLOW_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on TO_CHAR(P1.IS_REMAIN_DUE_AI) = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IBMS'
        AND R2.SRC_TAB_EN_NAME= 'IBMS_TTRD_SET_INSTRUCTION_SECU_HIS'
        AND R2.SRC_FIELD_EN_NAME= 'IS_REMAIN_DUE_AI'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_IBANK_TRAN_VCH_INSTR_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'INT_RECVBL_RESV_FLG'
    left join ${iml_schema}.ref_pub_cd_map r3 on TO_CHAR(P1.IS_REMAIN_DUE_CP) = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IBMS'
        AND R3.SRC_TAB_EN_NAME= 'IBMS_TTRD_SET_INSTRUCTION_SECU_HIS'
        AND R3.SRC_FIELD_EN_NAME= 'IS_REMAIN_DUE_CP'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_IBANK_TRAN_VCH_INSTR_DTL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'RECVBL_PRIC_RESV_FLG'
where  1 = 1 
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_tm 
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
        into ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,secu_instr_seq_num -- 券指令序号
    ,main_instr_seq_num -- 主指令序号
    ,ext_vch_acct_id -- 外部券账户编号
    ,intnal_vch_acct_id -- 内部券账户编号
    ,fin_instm_id -- 金融工具编号
    ,fin_instm_name -- 金融工具名称
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,merge_acpt_pay_id -- 合并收付编号
    ,cap_flow_dir_cd -- 资金流向代码
    ,curr_cd -- 币种代码
    ,fee_cost_chg -- 费用成本变动
    ,acru_int_cost_chg -- 应计利息成本变动
    ,actl_acru_int -- 实际应计利息
    ,actl_net_price_amt -- 实际净价金额
    ,recvbl_uncol_int -- 应收未收利息
    ,recvbl_uncol_pric -- 应收未收本金
    ,pl_fee -- 损益费用
    ,int_recvbl_resv_flg -- 应收利息保留标志
    ,recvbl_pric_resv_flg -- 应收本金保留标志
    ,bal_qtty_chg -- 余额数量变动
    ,froz_qtty -- 冻结数量
    ,calc_closing_dt -- 计算截止日期
    ,stl_dt -- 结算日期
    ,actl_stl_dt -- 实际结算日期
    ,prod_cls_name -- 产品分类名称
    ,full_price_cost_chg -- 全价成本变动
    ,ghb_zzd_trust_acct_num -- 本方中债登托管账号
    ,cntpty_zzd_trust_acct_num -- 对手中债登托管账号
    ,effect_tm -- 生效时间
    ,stl_denom -- 结算面额
    ,accti_tran_flow_num -- 核算交易流水号
    ,theory_fee -- 理论费用
    ,fee_cost -- 费用成本
    ,accti_impam_obj_flg -- 核算减值对象标志
    ,start_int_accr_dt -- 开始计息日期
    ,expect_qtty -- 预计数量
    ,expect_denom -- 预计面额
    ,operr_name -- 经办人名称
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,secu_instr_seq_num -- 券指令序号
    ,main_instr_seq_num -- 主指令序号
    ,ext_vch_acct_id -- 外部券账户编号
    ,intnal_vch_acct_id -- 内部券账户编号
    ,fin_instm_id -- 金融工具编号
    ,fin_instm_name -- 金融工具名称
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,merge_acpt_pay_id -- 合并收付编号
    ,cap_flow_dir_cd -- 资金流向代码
    ,curr_cd -- 币种代码
    ,fee_cost_chg -- 费用成本变动
    ,acru_int_cost_chg -- 应计利息成本变动
    ,actl_acru_int -- 实际应计利息
    ,actl_net_price_amt -- 实际净价金额
    ,recvbl_uncol_int -- 应收未收利息
    ,recvbl_uncol_pric -- 应收未收本金
    ,pl_fee -- 损益费用
    ,int_recvbl_resv_flg -- 应收利息保留标志
    ,recvbl_pric_resv_flg -- 应收本金保留标志
    ,bal_qtty_chg -- 余额数量变动
    ,froz_qtty -- 冻结数量
    ,calc_closing_dt -- 计算截止日期
    ,stl_dt -- 结算日期
    ,actl_stl_dt -- 实际结算日期
    ,prod_cls_name -- 产品分类名称
    ,full_price_cost_chg -- 全价成本变动
    ,ghb_zzd_trust_acct_num -- 本方中债登托管账号
    ,cntpty_zzd_trust_acct_num -- 对手中债登托管账号
    ,effect_tm -- 生效时间
    ,stl_denom -- 结算面额
    ,accti_tran_flow_num -- 核算交易流水号
    ,theory_fee -- 理论费用
    ,fee_cost -- 费用成本
    ,accti_impam_obj_flg -- 核算减值对象标志
    ,start_int_accr_dt -- 开始计息日期
    ,expect_qtty -- 预计数量
    ,expect_denom -- 预计面额
    ,operr_name -- 经办人名称
    ,remark -- 备注
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
    ,nvl(n.secu_instr_seq_num, o.secu_instr_seq_num) as secu_instr_seq_num -- 券指令序号
    ,nvl(n.main_instr_seq_num, o.main_instr_seq_num) as main_instr_seq_num -- 主指令序号
    ,nvl(n.ext_vch_acct_id, o.ext_vch_acct_id) as ext_vch_acct_id -- 外部券账户编号
    ,nvl(n.intnal_vch_acct_id, o.intnal_vch_acct_id) as intnal_vch_acct_id -- 内部券账户编号
    ,nvl(n.fin_instm_id, o.fin_instm_id) as fin_instm_id -- 金融工具编号
    ,nvl(n.fin_instm_name, o.fin_instm_name) as fin_instm_name -- 金融工具名称
    ,nvl(n.asset_type_id, o.asset_type_id) as asset_type_id -- 资产类型编号
    ,nvl(n.market_type_id, o.market_type_id) as market_type_id -- 市场类型编号
    ,nvl(n.merge_acpt_pay_id, o.merge_acpt_pay_id) as merge_acpt_pay_id -- 合并收付编号
    ,nvl(n.cap_flow_dir_cd, o.cap_flow_dir_cd) as cap_flow_dir_cd -- 资金流向代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.fee_cost_chg, o.fee_cost_chg) as fee_cost_chg -- 费用成本变动
    ,nvl(n.acru_int_cost_chg, o.acru_int_cost_chg) as acru_int_cost_chg -- 应计利息成本变动
    ,nvl(n.actl_acru_int, o.actl_acru_int) as actl_acru_int -- 实际应计利息
    ,nvl(n.actl_net_price_amt, o.actl_net_price_amt) as actl_net_price_amt -- 实际净价金额
    ,nvl(n.recvbl_uncol_int, o.recvbl_uncol_int) as recvbl_uncol_int -- 应收未收利息
    ,nvl(n.recvbl_uncol_pric, o.recvbl_uncol_pric) as recvbl_uncol_pric -- 应收未收本金
    ,nvl(n.pl_fee, o.pl_fee) as pl_fee -- 损益费用
    ,nvl(n.int_recvbl_resv_flg, o.int_recvbl_resv_flg) as int_recvbl_resv_flg -- 应收利息保留标志
    ,nvl(n.recvbl_pric_resv_flg, o.recvbl_pric_resv_flg) as recvbl_pric_resv_flg -- 应收本金保留标志
    ,nvl(n.bal_qtty_chg, o.bal_qtty_chg) as bal_qtty_chg -- 余额数量变动
    ,nvl(n.froz_qtty, o.froz_qtty) as froz_qtty -- 冻结数量
    ,nvl(n.calc_closing_dt, o.calc_closing_dt) as calc_closing_dt -- 计算截止日期
    ,nvl(n.stl_dt, o.stl_dt) as stl_dt -- 结算日期
    ,nvl(n.actl_stl_dt, o.actl_stl_dt) as actl_stl_dt -- 实际结算日期
    ,nvl(n.prod_cls_name, o.prod_cls_name) as prod_cls_name -- 产品分类名称
    ,nvl(n.full_price_cost_chg, o.full_price_cost_chg) as full_price_cost_chg -- 全价成本变动
    ,nvl(n.ghb_zzd_trust_acct_num, o.ghb_zzd_trust_acct_num) as ghb_zzd_trust_acct_num -- 本方中债登托管账号
    ,nvl(n.cntpty_zzd_trust_acct_num, o.cntpty_zzd_trust_acct_num) as cntpty_zzd_trust_acct_num -- 对手中债登托管账号
    ,nvl(n.effect_tm, o.effect_tm) as effect_tm -- 生效时间
    ,nvl(n.stl_denom, o.stl_denom) as stl_denom -- 结算面额
    ,nvl(n.accti_tran_flow_num, o.accti_tran_flow_num) as accti_tran_flow_num -- 核算交易流水号
    ,nvl(n.theory_fee, o.theory_fee) as theory_fee -- 理论费用
    ,nvl(n.fee_cost, o.fee_cost) as fee_cost -- 费用成本
    ,nvl(n.accti_impam_obj_flg, o.accti_impam_obj_flg) as accti_impam_obj_flg -- 核算减值对象标志
    ,nvl(n.start_int_accr_dt, o.start_int_accr_dt) as start_int_accr_dt -- 开始计息日期
    ,nvl(n.expect_qtty, o.expect_qtty) as expect_qtty -- 预计数量
    ,nvl(n.expect_denom, o.expect_denom) as expect_denom -- 预计面额
    ,nvl(n.operr_name, o.operr_name) as operr_name -- 经办人名称
    ,nvl(n.remark, o.remark) as remark -- 备注
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
from ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_tm n
    full join (select * from ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.secu_instr_seq_num <> n.secu_instr_seq_num
        or o.main_instr_seq_num <> n.main_instr_seq_num
        or o.ext_vch_acct_id <> n.ext_vch_acct_id
        or o.intnal_vch_acct_id <> n.intnal_vch_acct_id
        or o.fin_instm_id <> n.fin_instm_id
        or o.fin_instm_name <> n.fin_instm_name
        or o.asset_type_id <> n.asset_type_id
        or o.market_type_id <> n.market_type_id
        or o.merge_acpt_pay_id <> n.merge_acpt_pay_id
        or o.cap_flow_dir_cd <> n.cap_flow_dir_cd
        or o.curr_cd <> n.curr_cd
        or o.fee_cost_chg <> n.fee_cost_chg
        or o.acru_int_cost_chg <> n.acru_int_cost_chg
        or o.actl_acru_int <> n.actl_acru_int
        or o.actl_net_price_amt <> n.actl_net_price_amt
        or o.recvbl_uncol_int <> n.recvbl_uncol_int
        or o.recvbl_uncol_pric <> n.recvbl_uncol_pric
        or o.pl_fee <> n.pl_fee
        or o.int_recvbl_resv_flg <> n.int_recvbl_resv_flg
        or o.recvbl_pric_resv_flg <> n.recvbl_pric_resv_flg
        or o.bal_qtty_chg <> n.bal_qtty_chg
        or o.froz_qtty <> n.froz_qtty
        or o.calc_closing_dt <> n.calc_closing_dt
        or o.stl_dt <> n.stl_dt
        or o.actl_stl_dt <> n.actl_stl_dt
        or o.prod_cls_name <> n.prod_cls_name
        or o.full_price_cost_chg <> n.full_price_cost_chg
        or o.ghb_zzd_trust_acct_num <> n.ghb_zzd_trust_acct_num
        or o.cntpty_zzd_trust_acct_num <> n.cntpty_zzd_trust_acct_num
        or o.effect_tm <> n.effect_tm
        or o.stl_denom <> n.stl_denom
        or o.accti_tran_flow_num <> n.accti_tran_flow_num
        or o.theory_fee <> n.theory_fee
        or o.fee_cost <> n.fee_cost
        or o.accti_impam_obj_flg <> n.accti_impam_obj_flg
        or o.start_int_accr_dt <> n.start_int_accr_dt
        or o.expect_qtty <> n.expect_qtty
        or o.expect_denom <> n.expect_denom
        or o.operr_name <> n.operr_name
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,secu_instr_seq_num -- 券指令序号
    ,main_instr_seq_num -- 主指令序号
    ,ext_vch_acct_id -- 外部券账户编号
    ,intnal_vch_acct_id -- 内部券账户编号
    ,fin_instm_id -- 金融工具编号
    ,fin_instm_name -- 金融工具名称
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,merge_acpt_pay_id -- 合并收付编号
    ,cap_flow_dir_cd -- 资金流向代码
    ,curr_cd -- 币种代码
    ,fee_cost_chg -- 费用成本变动
    ,acru_int_cost_chg -- 应计利息成本变动
    ,actl_acru_int -- 实际应计利息
    ,actl_net_price_amt -- 实际净价金额
    ,recvbl_uncol_int -- 应收未收利息
    ,recvbl_uncol_pric -- 应收未收本金
    ,pl_fee -- 损益费用
    ,int_recvbl_resv_flg -- 应收利息保留标志
    ,recvbl_pric_resv_flg -- 应收本金保留标志
    ,bal_qtty_chg -- 余额数量变动
    ,froz_qtty -- 冻结数量
    ,calc_closing_dt -- 计算截止日期
    ,stl_dt -- 结算日期
    ,actl_stl_dt -- 实际结算日期
    ,prod_cls_name -- 产品分类名称
    ,full_price_cost_chg -- 全价成本变动
    ,ghb_zzd_trust_acct_num -- 本方中债登托管账号
    ,cntpty_zzd_trust_acct_num -- 对手中债登托管账号
    ,effect_tm -- 生效时间
    ,stl_denom -- 结算面额
    ,accti_tran_flow_num -- 核算交易流水号
    ,theory_fee -- 理论费用
    ,fee_cost -- 费用成本
    ,accti_impam_obj_flg -- 核算减值对象标志
    ,start_int_accr_dt -- 开始计息日期
    ,expect_qtty -- 预计数量
    ,expect_denom -- 预计面额
    ,operr_name -- 经办人名称
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,secu_instr_seq_num -- 券指令序号
    ,main_instr_seq_num -- 主指令序号
    ,ext_vch_acct_id -- 外部券账户编号
    ,intnal_vch_acct_id -- 内部券账户编号
    ,fin_instm_id -- 金融工具编号
    ,fin_instm_name -- 金融工具名称
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,merge_acpt_pay_id -- 合并收付编号
    ,cap_flow_dir_cd -- 资金流向代码
    ,curr_cd -- 币种代码
    ,fee_cost_chg -- 费用成本变动
    ,acru_int_cost_chg -- 应计利息成本变动
    ,actl_acru_int -- 实际应计利息
    ,actl_net_price_amt -- 实际净价金额
    ,recvbl_uncol_int -- 应收未收利息
    ,recvbl_uncol_pric -- 应收未收本金
    ,pl_fee -- 损益费用
    ,int_recvbl_resv_flg -- 应收利息保留标志
    ,recvbl_pric_resv_flg -- 应收本金保留标志
    ,bal_qtty_chg -- 余额数量变动
    ,froz_qtty -- 冻结数量
    ,calc_closing_dt -- 计算截止日期
    ,stl_dt -- 结算日期
    ,actl_stl_dt -- 实际结算日期
    ,prod_cls_name -- 产品分类名称
    ,full_price_cost_chg -- 全价成本变动
    ,ghb_zzd_trust_acct_num -- 本方中债登托管账号
    ,cntpty_zzd_trust_acct_num -- 对手中债登托管账号
    ,effect_tm -- 生效时间
    ,stl_denom -- 结算面额
    ,accti_tran_flow_num -- 核算交易流水号
    ,theory_fee -- 理论费用
    ,fee_cost -- 费用成本
    ,accti_impam_obj_flg -- 核算减值对象标志
    ,start_int_accr_dt -- 开始计息日期
    ,expect_qtty -- 预计数量
    ,expect_denom -- 预计面额
    ,operr_name -- 经办人名称
    ,remark -- 备注
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
    ,o.secu_instr_seq_num -- 券指令序号
    ,o.main_instr_seq_num -- 主指令序号
    ,o.ext_vch_acct_id -- 外部券账户编号
    ,o.intnal_vch_acct_id -- 内部券账户编号
    ,o.fin_instm_id -- 金融工具编号
    ,o.fin_instm_name -- 金融工具名称
    ,o.asset_type_id -- 资产类型编号
    ,o.market_type_id -- 市场类型编号
    ,o.merge_acpt_pay_id -- 合并收付编号
    ,o.cap_flow_dir_cd -- 资金流向代码
    ,o.curr_cd -- 币种代码
    ,o.fee_cost_chg -- 费用成本变动
    ,o.acru_int_cost_chg -- 应计利息成本变动
    ,o.actl_acru_int -- 实际应计利息
    ,o.actl_net_price_amt -- 实际净价金额
    ,o.recvbl_uncol_int -- 应收未收利息
    ,o.recvbl_uncol_pric -- 应收未收本金
    ,o.pl_fee -- 损益费用
    ,o.int_recvbl_resv_flg -- 应收利息保留标志
    ,o.recvbl_pric_resv_flg -- 应收本金保留标志
    ,o.bal_qtty_chg -- 余额数量变动
    ,o.froz_qtty -- 冻结数量
    ,o.calc_closing_dt -- 计算截止日期
    ,o.stl_dt -- 结算日期
    ,o.actl_stl_dt -- 实际结算日期
    ,o.prod_cls_name -- 产品分类名称
    ,o.full_price_cost_chg -- 全价成本变动
    ,o.ghb_zzd_trust_acct_num -- 本方中债登托管账号
    ,o.cntpty_zzd_trust_acct_num -- 对手中债登托管账号
    ,o.effect_tm -- 生效时间
    ,o.stl_denom -- 结算面额
    ,o.accti_tran_flow_num -- 核算交易流水号
    ,o.theory_fee -- 理论费用
    ,o.fee_cost -- 费用成本
    ,o.accti_impam_obj_flg -- 核算减值对象标志
    ,o.start_int_accr_dt -- 开始计息日期
    ,o.expect_qtty -- 预计数量
    ,o.expect_denom -- 预计面额
    ,o.operr_name -- 经办人名称
    ,o.remark -- 备注
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
from ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_bk o
    left join ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_cl d
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
--truncate table ${iml_schema}.evt_ibank_tran_vch_instr_dtl;
--alter table ${iml_schema}.evt_ibank_tran_vch_instr_dtl truncate partition for ('ibmsi1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_ibank_tran_vch_instr_dtl') 
               and substr(subpartition_name,1,8)=upper('p_ibmsi1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_ibank_tran_vch_instr_dtl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_ibank_tran_vch_instr_dtl modify partition p_ibmsi1 
add subpartition p_ibmsi1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_ibank_tran_vch_instr_dtl exchange subpartition p_ibmsi1_${batch_date} with table ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_cl;
alter table ${iml_schema}.evt_ibank_tran_vch_instr_dtl exchange subpartition p_ibmsi1_20991231 with table ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ibank_tran_vch_instr_dtl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_tm purge;
drop table ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_op purge;
drop table ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_ibank_tran_vch_instr_dtl_ibmsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ibank_tran_vch_instr_dtl', partname => 'p_ibmsi1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
