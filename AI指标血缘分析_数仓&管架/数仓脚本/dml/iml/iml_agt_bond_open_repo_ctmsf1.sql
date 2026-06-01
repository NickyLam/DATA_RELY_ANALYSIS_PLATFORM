/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bond_open_repo_ctmsf1
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
drop table ${iml_schema}.agt_bond_open_repo_ctmsf1_tm purge;
drop table ${iml_schema}.agt_bond_open_repo_ctmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_bond_open_repo add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_bond_open_repo modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bond_open_repo_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bond_open_repo partition for ('ctmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bond_open_repo_ctmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,bus_table_name -- 业务表名称
    ,dept_id -- 部门编号
    ,tran_id -- 交易编号
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,acct_b_id -- 账簿编号
    ,acct_b_name -- 账簿名称
    ,curr_cd -- 币种代码
    ,tran_dir_cd -- 交易方向代码
    ,fst_amt -- 首期金额
    ,tran_dt -- 交易日期
    ,fst_dlvy_dt -- 首期交割日期
    ,exp_dlvy_dt -- 到期交割日期
    ,bond_id -- 债券编号
    ,bond_name -- 债券名称
    ,cert_face_tot -- 券面总额
    ,fst_net_price -- 首期净价
    ,exp_net_price -- 到期净价
    ,exp_amt -- 到期金额
    ,acru_int -- 应计利息
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,dealer_id -- 交易员编号
    ,dealer_name -- 交易员名称
    ,fst_fee -- 首期费用
    ,fst_tax -- 首期税金
    ,fst_comm -- 首期佣金
    ,exp_fee -- 到期费用
    ,exp_tax -- 到期税金
    ,exp_comm -- 到期佣金
    ,tran_fee -- 交易费
    ,fst_dlvy_way_cd -- 首期交割方式代码
    ,exp_dlvy_way_cd -- 到期交割方式代码
    ,tran_src_cd -- 交易来源代码
    ,cfets_tran_flg -- CFETS交易标志
    ,near_end_link_denom -- 近端连结面额
    ,far_end_link_denom -- 远端连结面额
    ,link_init_tran_flg -- 连结原始交易标志
    ,accti_method_cd -- 核算方法代码
    ,init_bus_id -- 原业务编号
    ,acpt_pay_cfm_modif_tm -- 收付确认修改时间
    ,tran_status_cd -- 交易状态代码
    ,dc_dealer_name -- 本币交易员名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bond_open_repo
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_bond_open_repo_ctmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_bond_open_repo partition for ('ctmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ctms_tbs_vs_payment_openrepodeals-
insert into ${iml_schema}.agt_bond_open_repo_ctmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,bus_table_name -- 业务表名称
    ,dept_id -- 部门编号
    ,tran_id -- 交易编号
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,acct_b_id -- 账簿编号
    ,acct_b_name -- 账簿名称
    ,curr_cd -- 币种代码
    ,tran_dir_cd -- 交易方向代码
    ,fst_amt -- 首期金额
    ,tran_dt -- 交易日期
    ,fst_dlvy_dt -- 首期交割日期
    ,exp_dlvy_dt -- 到期交割日期
    ,bond_id -- 债券编号
    ,bond_name -- 债券名称
    ,cert_face_tot -- 券面总额
    ,fst_net_price -- 首期净价
    ,exp_net_price -- 到期净价
    ,exp_amt -- 到期金额
    ,acru_int -- 应计利息
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,dealer_id -- 交易员编号
    ,dealer_name -- 交易员名称
    ,fst_fee -- 首期费用
    ,fst_tax -- 首期税金
    ,fst_comm -- 首期佣金
    ,exp_fee -- 到期费用
    ,exp_tax -- 到期税金
    ,exp_comm -- 到期佣金
    ,tran_fee -- 交易费
    ,fst_dlvy_way_cd -- 首期交割方式代码
    ,exp_dlvy_way_cd -- 到期交割方式代码
    ,tran_src_cd -- 交易来源代码
    ,cfets_tran_flg -- CFETS交易标志
    ,near_end_link_denom -- 近端连结面额
    ,far_end_link_denom -- 远端连结面额
    ,link_init_tran_flg -- 连结原始交易标志
    ,accti_method_cd -- 核算方法代码
    ,init_bus_id -- 原业务编号
    ,acpt_pay_cfm_modif_tm -- 收付确认修改时间
    ,tran_status_cd -- 交易状态代码
    ,dc_dealer_name -- 本币交易员名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '225103'||TO_CHAR(P1.DEAL_ID) -- 协议编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.DEAL_ID) -- 业务编号
    ,P1.DEAL_TABLENAME -- 业务表名称
    ,TO_CHAR(P1.ASPCLIENT_ID) -- 部门编号
    ,P1.SERIAL_NUMBER -- 交易编号
    ,P1.PORTFOLIO_ID -- 投组编号
    ,P1.PORTFOLIO_NAME -- 投组名称
    ,TO_CHAR(P1.KEEPFOLDER_ID) -- 账簿编号
    ,P1.KEEPFOLDER_SHORTNAME -- 账簿名称
    ,P1.CURRENCY -- 币种代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.BUYORSELL END -- 交易方向代码
    ,P1.AMOUNT -- 首期金额
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRADE_DATE) -- 交易日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.VALUE_DATE) -- 首期交割日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.MATURITY_DATE) -- 到期交割日期
    ,P1.BONDSCODE -- 债券编号
    ,P1.BONDSNAME -- 债券名称
    ,P1.FACE_AMOUNT -- 券面总额
    ,P1.FIRST_PRICE -- 首期净价
    ,P1.MATURITY_PRICE -- 到期净价
    ,P1.MATURITY_AMOUNT -- 到期金额
    ,P1.INTEREST -- 应计利息
    ,TO_CHAR(P1.CPTY_ID) -- 交易对手编号
    ,P1.CPTY_NAME -- 交易对手名称
    ,P1.DEALER_ID -- 交易员编号
    ,P1.DEALER_NAME -- 交易员名称
    ,P1.FEE1 -- 首期费用
    ,P1.TAX_AMT1 -- 首期税金
    ,P1.BROKER_AMT1 -- 首期佣金
    ,P1.FEE2 -- 到期费用
    ,P1.TAX_AMT2 -- 到期税金
    ,P1.BROKER_AMT2 -- 到期佣金
    ,P1.TRADINGFEE -- 交易费
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.SETTLE_TYPE END -- 首期交割方式代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.SETTLE_TYPE2 END -- 到期交割方式代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.SOURCE END -- 交易来源代码
    ,P1.CFETS_FROM -- CFETS交易标志
    ,P1.SPOT_V -- 近端连结面额
    ,P1.FWD_V -- 远端连结面额
    ,P1.CSTP_REQ -- 连结原始交易标志
    ,P1.KEEP_TYPE -- 核算方法代码
    ,TO_CHAR(P1.OPENREPODEALS_ID_GRAND) -- 原业务编号
    ,P1.LASTMODIFIED_PAY -- 收付确认修改时间
    ,NVL(TRIM(P1.STATUS),'-') -- 交易状态代码
    ,P1.DN_DEALER -- 本币交易员名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_vs_payment_openrepodeals' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_vs_payment_openrepodeals p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.BUYORSELL = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'CTMS'
        AND R2.SRC_TAB_EN_NAME= 'CTMS_TBS_VS_PAYMENT_OPENREPODEALS'
        AND R2.SRC_FIELD_EN_NAME= 'BUYORSELL'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_BOND_OPEN_REPO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.SETTLE_TYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'CTMS'
        AND R3.SRC_TAB_EN_NAME= 'CTMS_TBS_VS_PAYMENT_OPENREPODEALS'
        AND R3.SRC_FIELD_EN_NAME= 'SETTLE_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_BOND_OPEN_REPO'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'FST_DLVY_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.SETTLE_TYPE2 = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'CTMS'
        AND R4.SRC_TAB_EN_NAME= 'CTMS_TBS_VS_PAYMENT_OPENREPODEALS'
        AND R4.SRC_FIELD_EN_NAME= 'SETTLE_TYPE2'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_BOND_OPEN_REPO'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'EXP_DLVY_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.SOURCE = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'CTMS'
        AND R5.SRC_TAB_EN_NAME= 'CTMS_TBS_VS_PAYMENT_OPENREPODEALS'
        AND R5.SRC_FIELD_EN_NAME= 'SOURCE'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_BOND_OPEN_REPO'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'TRAN_SRC_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_bond_open_repo_ctmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_bond_open_repo_ctmsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,bus_table_name -- 业务表名称
    ,dept_id -- 部门编号
    ,tran_id -- 交易编号
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,acct_b_id -- 账簿编号
    ,acct_b_name -- 账簿名称
    ,curr_cd -- 币种代码
    ,tran_dir_cd -- 交易方向代码
    ,fst_amt -- 首期金额
    ,tran_dt -- 交易日期
    ,fst_dlvy_dt -- 首期交割日期
    ,exp_dlvy_dt -- 到期交割日期
    ,bond_id -- 债券编号
    ,bond_name -- 债券名称
    ,cert_face_tot -- 券面总额
    ,fst_net_price -- 首期净价
    ,exp_net_price -- 到期净价
    ,exp_amt -- 到期金额
    ,acru_int -- 应计利息
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,dealer_id -- 交易员编号
    ,dealer_name -- 交易员名称
    ,fst_fee -- 首期费用
    ,fst_tax -- 首期税金
    ,fst_comm -- 首期佣金
    ,exp_fee -- 到期费用
    ,exp_tax -- 到期税金
    ,exp_comm -- 到期佣金
    ,tran_fee -- 交易费
    ,fst_dlvy_way_cd -- 首期交割方式代码
    ,exp_dlvy_way_cd -- 到期交割方式代码
    ,tran_src_cd -- 交易来源代码
    ,cfets_tran_flg -- CFETS交易标志
    ,near_end_link_denom -- 近端连结面额
    ,far_end_link_denom -- 远端连结面额
    ,link_init_tran_flg -- 连结原始交易标志
    ,accti_method_cd -- 核算方法代码
    ,init_bus_id -- 原业务编号
    ,acpt_pay_cfm_modif_tm -- 收付确认修改时间
    ,tran_status_cd -- 交易状态代码
    ,dc_dealer_name -- 本币交易员名称
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
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 业务编号
    ,nvl(n.bus_table_name, o.bus_table_name) as bus_table_name -- 业务表名称
    ,nvl(n.dept_id, o.dept_id) as dept_id -- 部门编号
    ,nvl(n.tran_id, o.tran_id) as tran_id -- 交易编号
    ,nvl(n.portf_id, o.portf_id) as portf_id -- 投组编号
    ,nvl(n.portf_name, o.portf_name) as portf_name -- 投组名称
    ,nvl(n.acct_b_id, o.acct_b_id) as acct_b_id -- 账簿编号
    ,nvl(n.acct_b_name, o.acct_b_name) as acct_b_name -- 账簿名称
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.tran_dir_cd, o.tran_dir_cd) as tran_dir_cd -- 交易方向代码
    ,nvl(n.fst_amt, o.fst_amt) as fst_amt -- 首期金额
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.fst_dlvy_dt, o.fst_dlvy_dt) as fst_dlvy_dt -- 首期交割日期
    ,nvl(n.exp_dlvy_dt, o.exp_dlvy_dt) as exp_dlvy_dt -- 到期交割日期
    ,nvl(n.bond_id, o.bond_id) as bond_id -- 债券编号
    ,nvl(n.bond_name, o.bond_name) as bond_name -- 债券名称
    ,nvl(n.cert_face_tot, o.cert_face_tot) as cert_face_tot -- 券面总额
    ,nvl(n.fst_net_price, o.fst_net_price) as fst_net_price -- 首期净价
    ,nvl(n.exp_net_price, o.exp_net_price) as exp_net_price -- 到期净价
    ,nvl(n.exp_amt, o.exp_amt) as exp_amt -- 到期金额
    ,nvl(n.acru_int, o.acru_int) as acru_int -- 应计利息
    ,nvl(n.cntpty_id, o.cntpty_id) as cntpty_id -- 交易对手编号
    ,nvl(n.cntpty_name, o.cntpty_name) as cntpty_name -- 交易对手名称
    ,nvl(n.dealer_id, o.dealer_id) as dealer_id -- 交易员编号
    ,nvl(n.dealer_name, o.dealer_name) as dealer_name -- 交易员名称
    ,nvl(n.fst_fee, o.fst_fee) as fst_fee -- 首期费用
    ,nvl(n.fst_tax, o.fst_tax) as fst_tax -- 首期税金
    ,nvl(n.fst_comm, o.fst_comm) as fst_comm -- 首期佣金
    ,nvl(n.exp_fee, o.exp_fee) as exp_fee -- 到期费用
    ,nvl(n.exp_tax, o.exp_tax) as exp_tax -- 到期税金
    ,nvl(n.exp_comm, o.exp_comm) as exp_comm -- 到期佣金
    ,nvl(n.tran_fee, o.tran_fee) as tran_fee -- 交易费
    ,nvl(n.fst_dlvy_way_cd, o.fst_dlvy_way_cd) as fst_dlvy_way_cd -- 首期交割方式代码
    ,nvl(n.exp_dlvy_way_cd, o.exp_dlvy_way_cd) as exp_dlvy_way_cd -- 到期交割方式代码
    ,nvl(n.tran_src_cd, o.tran_src_cd) as tran_src_cd -- 交易来源代码
    ,nvl(n.cfets_tran_flg, o.cfets_tran_flg) as cfets_tran_flg -- CFETS交易标志
    ,nvl(n.near_end_link_denom, o.near_end_link_denom) as near_end_link_denom -- 近端连结面额
    ,nvl(n.far_end_link_denom, o.far_end_link_denom) as far_end_link_denom -- 远端连结面额
    ,nvl(n.link_init_tran_flg, o.link_init_tran_flg) as link_init_tran_flg -- 连结原始交易标志
    ,nvl(n.accti_method_cd, o.accti_method_cd) as accti_method_cd -- 核算方法代码
    ,nvl(n.init_bus_id, o.init_bus_id) as init_bus_id -- 原业务编号
    ,nvl(n.acpt_pay_cfm_modif_tm, o.acpt_pay_cfm_modif_tm) as acpt_pay_cfm_modif_tm -- 收付确认修改时间
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.dc_dealer_name, o.dc_dealer_name) as dc_dealer_name -- 本币交易员名称
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.bus_id <> n.bus_id
                or o.bus_table_name <> n.bus_table_name
                or o.dept_id <> n.dept_id
                or o.tran_id <> n.tran_id
                or o.portf_id <> n.portf_id
                or o.portf_name <> n.portf_name
                or o.acct_b_id <> n.acct_b_id
                or o.acct_b_name <> n.acct_b_name
                or o.curr_cd <> n.curr_cd
                or o.tran_dir_cd <> n.tran_dir_cd
                or o.fst_amt <> n.fst_amt
                or o.tran_dt <> n.tran_dt
                or o.fst_dlvy_dt <> n.fst_dlvy_dt
                or o.exp_dlvy_dt <> n.exp_dlvy_dt
                or o.bond_id <> n.bond_id
                or o.bond_name <> n.bond_name
                or o.cert_face_tot <> n.cert_face_tot
                or o.fst_net_price <> n.fst_net_price
                or o.exp_net_price <> n.exp_net_price
                or o.exp_amt <> n.exp_amt
                or o.acru_int <> n.acru_int
                or o.cntpty_id <> n.cntpty_id
                or o.cntpty_name <> n.cntpty_name
                or o.dealer_id <> n.dealer_id
                or o.dealer_name <> n.dealer_name
                or o.fst_fee <> n.fst_fee
                or o.fst_tax <> n.fst_tax
                or o.fst_comm <> n.fst_comm
                or o.exp_fee <> n.exp_fee
                or o.exp_tax <> n.exp_tax
                or o.exp_comm <> n.exp_comm
                or o.tran_fee <> n.tran_fee
                or o.fst_dlvy_way_cd <> n.fst_dlvy_way_cd
                or o.exp_dlvy_way_cd <> n.exp_dlvy_way_cd
                or o.tran_src_cd <> n.tran_src_cd
                or o.cfets_tran_flg <> n.cfets_tran_flg
                or o.near_end_link_denom <> n.near_end_link_denom
                or o.far_end_link_denom <> n.far_end_link_denom
                or o.link_init_tran_flg <> n.link_init_tran_flg
                or o.accti_method_cd <> n.accti_method_cd
                or o.init_bus_id <> n.init_bus_id
                or o.acpt_pay_cfm_modif_tm <> n.acpt_pay_cfm_modif_tm
                or o.tran_status_cd <> n.tran_status_cd
                or o.dc_dealer_name <> n.dc_dealer_name
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
from ${iml_schema}.agt_bond_open_repo_ctmsf1_tm n
    full join ${iml_schema}.agt_bond_open_repo_ctmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_bond_open_repo truncate partition for ('ctmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_bond_open_repo exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.agt_bond_open_repo_ctmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_bond_open_repo drop subpartition p_ctmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bond_open_repo to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_bond_open_repo_ctmsf1_tm purge;
drop table ${iml_schema}.agt_bond_open_repo_ctmsf1_ex purge;
drop table ${iml_schema}.agt_bond_open_repo_ctmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bond_open_repo', partname => 'p_ctmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);