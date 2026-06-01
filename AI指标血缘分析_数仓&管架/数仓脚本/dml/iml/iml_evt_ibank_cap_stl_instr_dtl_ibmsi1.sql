/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ibank_cap_stl_instr_dtl_ibmsi1
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
alter table ${iml_schema}.evt_ibank_cap_stl_instr_dtl add partition p_ibmsi1 values ('ibmsi1')(
        subpartition p_ibmsi1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ibmsi1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_ibank_cap_stl_instr_dtl partition for ('ibmsi1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_tm purge;
drop table ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_op purge;
drop table ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,cap_instr_seq_num -- 资金指令序号
    ,main_instr_seq_num -- 主指令序号
    ,level2_cap_acct_id -- 二级资金账户编号
    ,level1_cap_acct_id -- 一级资金账户编号
    ,cap_flow_dir_cd -- 资金流向代码
    ,curr_cd -- 币种代码
    ,chg_qtty -- 变动数量
    ,froz_qtty -- 冻结数量
    ,stl_dt -- 结算日期
    ,actl_stl_dt -- 实际结算日期
    ,tran_way_cd -- 转账方式代码
    ,ghb_bank_acct_num -- 本方银行账户编号
    ,ghb_bank_acct_name -- 本方银行账户名称
    ,ghb_open_bank_num -- 本方开户行号
    ,ghb_open_bank_name -- 本方开户行名称
    ,cntpty_bank_no -- 交易对手银行行号
    ,cntpty_bank_acct_num -- 对手银行账号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_open_bank_num -- 交易对手开户行号
    ,cntpty_open_bank_name -- 交易对手开户行名称
    ,oper_tm -- 经办时间
    ,operr_name -- 经办人名称
    ,merge_acpt_pay_id -- 合并收付编号
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ibank_cap_stl_instr_dtl partition for ('ibmsi1')
where 0=1
;

create table ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_ibank_cap_stl_instr_dtl partition for ('ibmsi1') where 0=1;

create table ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_ibank_cap_stl_instr_dtl partition for ('ibmsi1') where 0=1;

-- 3.1 get new data into table
-- ibms_ttrd_set_instruction_cash-1
insert into ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,cap_instr_seq_num -- 资金指令序号
    ,main_instr_seq_num -- 主指令序号
    ,level2_cap_acct_id -- 二级资金账户编号
    ,level1_cap_acct_id -- 一级资金账户编号
    ,cap_flow_dir_cd -- 资金流向代码
    ,curr_cd -- 币种代码
    ,chg_qtty -- 变动数量
    ,froz_qtty -- 冻结数量
    ,stl_dt -- 结算日期
    ,actl_stl_dt -- 实际结算日期
    ,tran_way_cd -- 转账方式代码
    ,ghb_bank_acct_num -- 本方银行账户编号
    ,ghb_bank_acct_name -- 本方银行账户名称
    ,ghb_open_bank_num -- 本方开户行号
    ,ghb_open_bank_name -- 本方开户行名称
    ,cntpty_bank_no -- 交易对手银行行号
    ,cntpty_bank_acct_num -- 对手银行账号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_open_bank_num -- 交易对手开户行号
    ,cntpty_open_bank_name -- 交易对手开户行名称
    ,oper_tm -- 经办时间
    ,operr_name -- 经办人名称
    ,merge_acpt_pay_id -- 合并收付编号
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '105004'||TO_CHAR(P1.CASH_INST_ID) -- 事件编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.CASH_INST_ID) -- 资金指令序号
    ,TO_CHAR(P1.INST_ID) -- 主指令序号
    ,P1.CASH_ACCT_ID -- 二级资金账户编号
    ,P1.EXT_CASH_ACCT_ID -- 一级资金账户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DIRECTION END -- 资金流向代码
    ,NVL(TRIM(P1.CURRENCY),'-') -- 币种代码
    ,P1.AMOUNT -- 变动数量
    ,P1.FREEZE_AMOUNT -- 冻结数量
    ,${iml_schema}.DATEFORMAT_MIN(P1.SET_DATE) -- 结算日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.SET_FINISH_DATE) -- 实际结算日期
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||TO_CHAR(P1.TRANSFER_TYPE) END -- 转账方式代码
    ,P1.ACCT_CODE -- 本方银行账户编号
    ,P1.ACCT_NAME -- 本方银行账户名称
    ,P1.BANK_CODE -- 本方开户行号
    ,P1.BANK_NAME -- 本方开户行名称
    ,P1.PARTY_I_BANK_CODE -- 交易对手银行行号
    ,P1.PARTY_ACCT_CODE -- 对手银行账号
    ,P1.PARTY_ACCT_NAME -- 交易对手账户名称
    ,P1.PARTY_BANK_CODE -- 交易对手开户行号
    ,P1.PARTY_BANK_NAME -- 交易对手开户行名称
    ,${iml_schema}.TIMEFORMAT_MIN(P1.UPDATE_TIME) -- 经办时间
    ,P1.UPDATE_USER -- 经办人名称
    ,P1.CASH_INST_SETGRP_ID -- 合并收付编号
    ,P1.MEMO -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_set_instruction_cash' -- 源表名称
    ,'ibmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_set_instruction_cash p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DIRECTION = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IBMS'
        AND R1.SRC_TAB_EN_NAME= 'IBMS_TTRD_SET_INSTRUCTION_CASH'
        AND R1.SRC_FIELD_EN_NAME= 'DIRECTION'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_IBANK_CAP_STL_INSTR_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CAP_FLOW_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on TO_CHAR(P1.TRANSFER_TYPE) = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IBMS'
        AND R2.SRC_TAB_EN_NAME= 'IBMS_TTRD_SET_INSTRUCTION_CASH'
        AND R2.SRC_FIELD_EN_NAME= 'TRANSFER_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_IBANK_CAP_STL_INSTR_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
        and not exists (select 1 
                      from iol.ibms_ttrd_set_instruction_cash_his t1
                     where p1.CASH_INST_ID = t1.CASH_INST_ID)
;
commit;

-- ibms_ttrd_set_instruction_cash_his-1
insert into ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,cap_instr_seq_num -- 资金指令序号
    ,main_instr_seq_num -- 主指令序号
    ,level2_cap_acct_id -- 二级资金账户编号
    ,level1_cap_acct_id -- 一级资金账户编号
    ,cap_flow_dir_cd -- 资金流向代码
    ,curr_cd -- 币种代码
    ,chg_qtty -- 变动数量
    ,froz_qtty -- 冻结数量
    ,stl_dt -- 结算日期
    ,actl_stl_dt -- 实际结算日期
    ,tran_way_cd -- 转账方式代码
    ,ghb_bank_acct_num -- 本方银行账户编号
    ,ghb_bank_acct_name -- 本方银行账户名称
    ,ghb_open_bank_num -- 本方开户行号
    ,ghb_open_bank_name -- 本方开户行名称
    ,cntpty_bank_no -- 交易对手银行行号
    ,cntpty_bank_acct_num -- 对手银行账号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_open_bank_num -- 交易对手开户行号
    ,cntpty_open_bank_name -- 交易对手开户行名称
    ,oper_tm -- 经办时间
    ,operr_name -- 经办人名称
    ,merge_acpt_pay_id -- 合并收付编号
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '105004'||TO_CHAR(P1.CASH_INST_ID) -- 事件编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.CASH_INST_ID) -- 资金指令序号
    ,TO_CHAR(P1.INST_ID) -- 主指令序号
    ,P1.CASH_ACCT_ID -- 二级资金账户编号
    ,P1.EXT_CASH_ACCT_ID -- 一级资金账户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DIRECTION END -- 资金流向代码
    ,NVL(TRIM(P1.CURRENCY),'-') -- 币种代码
    ,P1.AMOUNT -- 变动数量
    ,P1.FREEZE_AMOUNT -- 冻结数量
    ,${iml_schema}.DATEFORMAT_MIN(P1.SET_DATE) -- 结算日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.SET_FINISH_DATE) -- 实际结算日期
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||TO_CHAR(P1.TRANSFER_TYPE) END -- 转账方式代码
    ,P1.ACCT_CODE -- 本方银行账户编号
    ,P1.ACCT_NAME -- 本方银行账户名称
    ,P1.BANK_CODE -- 本方开户行号
    ,P1.BANK_NAME -- 本方开户行名称
    ,P1.PARTY_I_BANK_CODE -- 交易对手银行行号
    ,P1.PARTY_ACCT_CODE -- 对手银行账号
    ,P1.PARTY_ACCT_NAME -- 交易对手账户名称
    ,P1.PARTY_BANK_CODE -- 交易对手开户行号
    ,P1.PARTY_BANK_NAME -- 交易对手开户行名称
    ,${iml_schema}.TIMEFORMAT_MIN(P1.UPDATE_TIME) -- 经办时间
    ,P1.UPDATE_USER -- 经办人名称
    ,P1.CASH_INST_SETGRP_ID -- 合并收付编号
    ,P1.MEMO -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_set_instruction_cash_his' -- 源表名称
    ,'ibmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_set_instruction_cash_his p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DIRECTION = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IBMS'
        AND R1.SRC_TAB_EN_NAME= 'IBMS_TTRD_SET_INSTRUCTION_CASH_HIS'
        AND R1.SRC_FIELD_EN_NAME= 'DIRECTION'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_IBANK_CAP_STL_INSTR_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CAP_FLOW_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on TO_CHAR(P1.TRANSFER_TYPE) = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IBMS'
        AND R2.SRC_TAB_EN_NAME= 'IBMS_TTRD_SET_INSTRUCTION_CASH_HIS'
        AND R2.SRC_FIELD_EN_NAME= 'TRANSFER_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_IBANK_CAP_STL_INSTR_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_WAY_CD'
where  1 = 1 
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_tm 
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
        into ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,cap_instr_seq_num -- 资金指令序号
    ,main_instr_seq_num -- 主指令序号
    ,level2_cap_acct_id -- 二级资金账户编号
    ,level1_cap_acct_id -- 一级资金账户编号
    ,cap_flow_dir_cd -- 资金流向代码
    ,curr_cd -- 币种代码
    ,chg_qtty -- 变动数量
    ,froz_qtty -- 冻结数量
    ,stl_dt -- 结算日期
    ,actl_stl_dt -- 实际结算日期
    ,tran_way_cd -- 转账方式代码
    ,ghb_bank_acct_num -- 本方银行账户编号
    ,ghb_bank_acct_name -- 本方银行账户名称
    ,ghb_open_bank_num -- 本方开户行号
    ,ghb_open_bank_name -- 本方开户行名称
    ,cntpty_bank_no -- 交易对手银行行号
    ,cntpty_bank_acct_num -- 对手银行账号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_open_bank_num -- 交易对手开户行号
    ,cntpty_open_bank_name -- 交易对手开户行名称
    ,oper_tm -- 经办时间
    ,operr_name -- 经办人名称
    ,merge_acpt_pay_id -- 合并收付编号
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,cap_instr_seq_num -- 资金指令序号
    ,main_instr_seq_num -- 主指令序号
    ,level2_cap_acct_id -- 二级资金账户编号
    ,level1_cap_acct_id -- 一级资金账户编号
    ,cap_flow_dir_cd -- 资金流向代码
    ,curr_cd -- 币种代码
    ,chg_qtty -- 变动数量
    ,froz_qtty -- 冻结数量
    ,stl_dt -- 结算日期
    ,actl_stl_dt -- 实际结算日期
    ,tran_way_cd -- 转账方式代码
    ,ghb_bank_acct_num -- 本方银行账户编号
    ,ghb_bank_acct_name -- 本方银行账户名称
    ,ghb_open_bank_num -- 本方开户行号
    ,ghb_open_bank_name -- 本方开户行名称
    ,cntpty_bank_no -- 交易对手银行行号
    ,cntpty_bank_acct_num -- 对手银行账号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_open_bank_num -- 交易对手开户行号
    ,cntpty_open_bank_name -- 交易对手开户行名称
    ,oper_tm -- 经办时间
    ,operr_name -- 经办人名称
    ,merge_acpt_pay_id -- 合并收付编号
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
    ,nvl(n.cap_instr_seq_num, o.cap_instr_seq_num) as cap_instr_seq_num -- 资金指令序号
    ,nvl(n.main_instr_seq_num, o.main_instr_seq_num) as main_instr_seq_num -- 主指令序号
    ,nvl(n.level2_cap_acct_id, o.level2_cap_acct_id) as level2_cap_acct_id -- 二级资金账户编号
    ,nvl(n.level1_cap_acct_id, o.level1_cap_acct_id) as level1_cap_acct_id -- 一级资金账户编号
    ,nvl(n.cap_flow_dir_cd, o.cap_flow_dir_cd) as cap_flow_dir_cd -- 资金流向代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.chg_qtty, o.chg_qtty) as chg_qtty -- 变动数量
    ,nvl(n.froz_qtty, o.froz_qtty) as froz_qtty -- 冻结数量
    ,nvl(n.stl_dt, o.stl_dt) as stl_dt -- 结算日期
    ,nvl(n.actl_stl_dt, o.actl_stl_dt) as actl_stl_dt -- 实际结算日期
    ,nvl(n.tran_way_cd, o.tran_way_cd) as tran_way_cd -- 转账方式代码
    ,nvl(n.ghb_bank_acct_num, o.ghb_bank_acct_num) as ghb_bank_acct_num -- 本方银行账户编号
    ,nvl(n.ghb_bank_acct_name, o.ghb_bank_acct_name) as ghb_bank_acct_name -- 本方银行账户名称
    ,nvl(n.ghb_open_bank_num, o.ghb_open_bank_num) as ghb_open_bank_num -- 本方开户行号
    ,nvl(n.ghb_open_bank_name, o.ghb_open_bank_name) as ghb_open_bank_name -- 本方开户行名称
    ,nvl(n.cntpty_bank_no, o.cntpty_bank_no) as cntpty_bank_no -- 交易对手银行行号
    ,nvl(n.cntpty_bank_acct_num, o.cntpty_bank_acct_num) as cntpty_bank_acct_num -- 对手银行账号
    ,nvl(n.cntpty_acct_name, o.cntpty_acct_name) as cntpty_acct_name -- 交易对手账户名称
    ,nvl(n.cntpty_open_bank_num, o.cntpty_open_bank_num) as cntpty_open_bank_num -- 交易对手开户行号
    ,nvl(n.cntpty_open_bank_name, o.cntpty_open_bank_name) as cntpty_open_bank_name -- 交易对手开户行名称
    ,nvl(n.oper_tm, o.oper_tm) as oper_tm -- 经办时间
    ,nvl(n.operr_name, o.operr_name) as operr_name -- 经办人名称
    ,nvl(n.merge_acpt_pay_id, o.merge_acpt_pay_id) as merge_acpt_pay_id -- 合并收付编号
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
from ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_tm n
    full join (select * from ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.cap_instr_seq_num <> n.cap_instr_seq_num
        or o.main_instr_seq_num <> n.main_instr_seq_num
        or o.level2_cap_acct_id <> n.level2_cap_acct_id
        or o.level1_cap_acct_id <> n.level1_cap_acct_id
        or o.cap_flow_dir_cd <> n.cap_flow_dir_cd
        or o.curr_cd <> n.curr_cd
        or o.chg_qtty <> n.chg_qtty
        or o.froz_qtty <> n.froz_qtty
        or o.stl_dt <> n.stl_dt
        or o.actl_stl_dt <> n.actl_stl_dt
        or o.tran_way_cd <> n.tran_way_cd
        or o.ghb_bank_acct_num <> n.ghb_bank_acct_num
        or o.ghb_bank_acct_name <> n.ghb_bank_acct_name
        or o.ghb_open_bank_num <> n.ghb_open_bank_num
        or o.ghb_open_bank_name <> n.ghb_open_bank_name
        or o.cntpty_bank_no <> n.cntpty_bank_no
        or o.cntpty_bank_acct_num <> n.cntpty_bank_acct_num
        or o.cntpty_acct_name <> n.cntpty_acct_name
        or o.cntpty_open_bank_num <> n.cntpty_open_bank_num
        or o.cntpty_open_bank_name <> n.cntpty_open_bank_name
        or o.oper_tm <> n.oper_tm
        or o.operr_name <> n.operr_name
        or o.merge_acpt_pay_id <> n.merge_acpt_pay_id
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,cap_instr_seq_num -- 资金指令序号
    ,main_instr_seq_num -- 主指令序号
    ,level2_cap_acct_id -- 二级资金账户编号
    ,level1_cap_acct_id -- 一级资金账户编号
    ,cap_flow_dir_cd -- 资金流向代码
    ,curr_cd -- 币种代码
    ,chg_qtty -- 变动数量
    ,froz_qtty -- 冻结数量
    ,stl_dt -- 结算日期
    ,actl_stl_dt -- 实际结算日期
    ,tran_way_cd -- 转账方式代码
    ,ghb_bank_acct_num -- 本方银行账户编号
    ,ghb_bank_acct_name -- 本方银行账户名称
    ,ghb_open_bank_num -- 本方开户行号
    ,ghb_open_bank_name -- 本方开户行名称
    ,cntpty_bank_no -- 交易对手银行行号
    ,cntpty_bank_acct_num -- 对手银行账号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_open_bank_num -- 交易对手开户行号
    ,cntpty_open_bank_name -- 交易对手开户行名称
    ,oper_tm -- 经办时间
    ,operr_name -- 经办人名称
    ,merge_acpt_pay_id -- 合并收付编号
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,cap_instr_seq_num -- 资金指令序号
    ,main_instr_seq_num -- 主指令序号
    ,level2_cap_acct_id -- 二级资金账户编号
    ,level1_cap_acct_id -- 一级资金账户编号
    ,cap_flow_dir_cd -- 资金流向代码
    ,curr_cd -- 币种代码
    ,chg_qtty -- 变动数量
    ,froz_qtty -- 冻结数量
    ,stl_dt -- 结算日期
    ,actl_stl_dt -- 实际结算日期
    ,tran_way_cd -- 转账方式代码
    ,ghb_bank_acct_num -- 本方银行账户编号
    ,ghb_bank_acct_name -- 本方银行账户名称
    ,ghb_open_bank_num -- 本方开户行号
    ,ghb_open_bank_name -- 本方开户行名称
    ,cntpty_bank_no -- 交易对手银行行号
    ,cntpty_bank_acct_num -- 对手银行账号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_open_bank_num -- 交易对手开户行号
    ,cntpty_open_bank_name -- 交易对手开户行名称
    ,oper_tm -- 经办时间
    ,operr_name -- 经办人名称
    ,merge_acpt_pay_id -- 合并收付编号
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
    ,o.cap_instr_seq_num -- 资金指令序号
    ,o.main_instr_seq_num -- 主指令序号
    ,o.level2_cap_acct_id -- 二级资金账户编号
    ,o.level1_cap_acct_id -- 一级资金账户编号
    ,o.cap_flow_dir_cd -- 资金流向代码
    ,o.curr_cd -- 币种代码
    ,o.chg_qtty -- 变动数量
    ,o.froz_qtty -- 冻结数量
    ,o.stl_dt -- 结算日期
    ,o.actl_stl_dt -- 实际结算日期
    ,o.tran_way_cd -- 转账方式代码
    ,o.ghb_bank_acct_num -- 本方银行账户编号
    ,o.ghb_bank_acct_name -- 本方银行账户名称
    ,o.ghb_open_bank_num -- 本方开户行号
    ,o.ghb_open_bank_name -- 本方开户行名称
    ,o.cntpty_bank_no -- 交易对手银行行号
    ,o.cntpty_bank_acct_num -- 对手银行账号
    ,o.cntpty_acct_name -- 交易对手账户名称
    ,o.cntpty_open_bank_num -- 交易对手开户行号
    ,o.cntpty_open_bank_name -- 交易对手开户行名称
    ,o.oper_tm -- 经办时间
    ,o.operr_name -- 经办人名称
    ,o.merge_acpt_pay_id -- 合并收付编号
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
from ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_bk o
    left join ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_cl d
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
--truncate table ${iml_schema}.evt_ibank_cap_stl_instr_dtl;
--alter table ${iml_schema}.evt_ibank_cap_stl_instr_dtl truncate partition for ('ibmsi1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_ibank_cap_stl_instr_dtl') 
               and substr(subpartition_name,1,8)=upper('p_ibmsi1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_ibank_cap_stl_instr_dtl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_ibank_cap_stl_instr_dtl modify partition p_ibmsi1 
add subpartition p_ibmsi1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_ibank_cap_stl_instr_dtl exchange subpartition p_ibmsi1_${batch_date} with table ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_cl;
alter table ${iml_schema}.evt_ibank_cap_stl_instr_dtl exchange subpartition p_ibmsi1_20991231 with table ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ibank_cap_stl_instr_dtl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_tm purge;
drop table ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_op purge;
drop table ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_ibank_cap_stl_instr_dtl_ibmsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ibank_cap_stl_instr_dtl', partname => 'p_ibmsi1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
