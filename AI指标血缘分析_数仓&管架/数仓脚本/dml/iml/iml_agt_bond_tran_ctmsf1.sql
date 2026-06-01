/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bond_tran_ctmsf1
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
drop table ${iml_schema}.agt_bond_tran_ctmsf1_tm purge;
drop table ${iml_schema}.agt_bond_tran_ctmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_bond_tran add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_bond_tran modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bond_tran_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bond_tran partition for ('ctmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bond_tran_ctmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,bus_table_name -- 业务表名称
    ,dept_id -- 部门编号
    ,bond_id -- 债券编号
    ,bond_name -- 债券名称
    ,bond_type_cd -- 债券类型代码
    ,std_prod_id -- 标准产品编号
    ,tran_id -- 交易编号
    ,tran_dt -- 交易日期
    ,dlvy_dt -- 交割日期
    ,tran_dir_cd -- 交易方向代码
    ,curr_cd -- 币种代码
    ,tran_net_price -- 交易净价
    ,tran_full_price -- 交易全价
    ,exp_yld_rat -- 到期收益率
    ,stl_amt -- 结算金额
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,acct_b_id -- 账簿编号
    ,acct_b_name -- 账簿名称
    ,acct_b_attr_cd -- 账簿属性代码
    ,asset_cls4_cd -- 资产四分类代码
    ,cntpty_name -- 交易对手名称
    ,cntpty_id -- 交易对手编号
    ,stl_way_cd -- 结算方式代码
    ,dealer_id -- 交易员编号
    ,dealer_name -- 交易员名称
    ,bag_id -- 成交编号
    ,comm_fee -- 手续费
    ,tax -- 税金
    ,comm -- 佣金
    ,cert_face_tot -- 券面总额
    ,acru_int_tot -- 应计利息总额
    ,cfets_tran_flg -- CFETS交易标志
    ,tran_src_cd -- 交易来源代码
    ,asset_type_cd -- 资产类型代码
    ,init_bus_id -- 原业务编号
    ,acpt_pay_cfm_modif_tm -- 收付确认修改时间
    ,tran_status_cd -- 交易状态代码
    ,dc_dealer_name -- 本币交易员名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bond_tran
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_bond_tran_ctmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_bond_tran partition for ('ctmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ctms_tbs_v_bondsdeals-
insert into ${iml_schema}.agt_bond_tran_ctmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,bus_table_name -- 业务表名称
    ,dept_id -- 部门编号
    ,bond_id -- 债券编号
    ,bond_name -- 债券名称
    ,bond_type_cd -- 债券类型代码
    ,std_prod_id -- 标准产品编号
    ,tran_id -- 交易编号
    ,tran_dt -- 交易日期
    ,dlvy_dt -- 交割日期
    ,tran_dir_cd -- 交易方向代码
    ,curr_cd -- 币种代码
    ,tran_net_price -- 交易净价
    ,tran_full_price -- 交易全价
    ,exp_yld_rat -- 到期收益率
    ,stl_amt -- 结算金额
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,acct_b_id -- 账簿编号
    ,acct_b_name -- 账簿名称
    ,acct_b_attr_cd -- 账簿属性代码
    ,asset_cls4_cd -- 资产四分类代码
    ,cntpty_name -- 交易对手名称
    ,cntpty_id -- 交易对手编号
    ,stl_way_cd -- 结算方式代码
    ,dealer_id -- 交易员编号
    ,dealer_name -- 交易员名称
    ,bag_id -- 成交编号
    ,comm_fee -- 手续费
    ,tax -- 税金
    ,comm -- 佣金
    ,cert_face_tot -- 券面总额
    ,acru_int_tot -- 应计利息总额
    ,cfets_tran_flg -- CFETS交易标志
    ,tran_src_cd -- 交易来源代码
    ,asset_type_cd -- 资产类型代码
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
    '225101'||TO_CHAR(P1.DEAL_ID) -- 协议编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.DEAL_ID) -- 业务编号
    ,P1.DEAL_TABLENAME -- 业务表名称
    ,TO_CHAR(P1.ASPCLIENT_ID) -- 部门编号
    ,P1.BONDSCODE -- 债券编号
    ,P1.BONDSNAME -- 债券名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE P6.SECURITY_TYPE_NEW END -- 债券类型代码
    ,nvl(trim(p5.PRODUCT_CODE),' ') -- 标准产品编号
    ,P1.SERIAL_NUMBER -- 交易编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRADEDATE) -- 交易日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.SETTLEDATE) -- 交割日期
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.BUYORSELL END -- 交易方向代码
    ,P1.CURRENCY -- 币种代码
    ,P1.CLEANPRICE -- 交易净价
    ,P1.DIRTYPRICE -- 交易全价
    ,P1.YIELDTOMATURITY -- 到期收益率
    ,P1.SETTLEAMOUNT -- 结算金额
    ,TO_CHAR(P1.PORTFOLIO_ID) -- 投组编号
    ,P1.PORTFOLIO_NAME -- 投组名称
    ,TO_CHAR(P1.KEEPFOLDER_ID) -- 账簿编号
    ,P1.KEEPFOLDER_SHORTNAME -- 账簿名称
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.FOLDERATTS END -- 账簿属性代码
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P3.ASSETTYPE_ID END -- 资产四分类代码
    ,P1.CPTYS_SHORTNAME -- 交易对手名称
    ,nvl(trim(P2.CPTYS_ID),' ') -- 交易对手编号
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.SETTLETYPE END -- 结算方式代码
    ,P1.DEALER_ID -- 交易员编号
    ,P1.DEALER_NAME -- 交易员名称
    ,P1.REF_NUMBER -- 成交编号
    ,P1.FEEAMOUNT -- 手续费
    ,P1.TAXAMOUNT -- 税金
    ,P1.BROKERAMOUNT -- 佣金
    ,P1.NOMINAL -- 券面总额
    ,P1.ACCRUEDAMOUNT -- 应计利息总额
    ,P1.CFETS_FROM -- CFETS交易标志
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.SOURCE END -- 交易来源代码
    ,TO_CHAR(P1.ASSETTYPE_ID) -- 资产类型代码
    ,TO_CHAR(P1.BONDSDEALS_ID_GRAND) -- 原业务编号
    ,nvl(trim(P7.LASTMODIFIED_PAY),to_timestamp('20991231', 'yyyy-mm-dd hh24:mi:ss.ff6')) -- 收付确认修改时间
    ,nvl(trim(P7.STATUS),'-') -- 交易状态代码
    ,P1.DN_DEALER -- 本币交易员名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_v_bondsdeals' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.ctms_tbs_v_bondsdeals p1
  left join ${iol_schema}.ctms_tbs_vs_cptys p2
    on p1.cptys_id = p2.key_src
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ctms_tbs_vs_assettype p3
    on p1.classfyname = p3.assettype_name
   and p3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p3.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ctms_tbs_v_security p6
    on p1.bondscode = p6.security_code
   and p6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p6.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ctms_tbs_vs_payment_bondsdeals p7
    on p1.deal_id = p7.deal_id
   and p1.deal_tablename = p7.deal_tablename
   and p7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p7.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.ref_pub_cd_map r1
    on p1.bondstype = r1.src_code_val
   and r1.sorc_sys_cd = 'CTMS'
   and r1.src_tab_en_name = 'CTMS_TBS_V_BONDSDEALS'
   and r1.src_field_en_name = 'BONDSTYPE'
   and r1.target_tab_en_name = 'AGT_BOND_TRAN'
   and r1.target_tab_field_en_name = 'BOND_TYPE_CD'
  left join (select max(balance_id) as max_balance_id,
                    buztype,
                    assettype,
                    keepfolder_id,
                    majorassetcode,
                    minorassetcode
               from ${iol_schema}.ctms_tbs_v_new_balance
              group by buztype,
                       assettype,
                       keepfolder_id,
                       majorassetcode,
                       minorassetcode) t
    on p1.keepfolder_id = t.keepfolder_id
   and p1.bondscode = t.majorassetcode
   and t.buztype in ('现券', '债券发行')
  left join ${iol_schema}.ctms_tbs_v_new_balance p5
    on t.max_balance_id = p5.balance_id
   and p5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p5.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.ref_pub_cd_map r6
    on p1.buyorsell = r6.src_code_val
   and r6.sorc_sys_cd = 'CTMS'
   and r6.src_tab_en_name = 'CTMS_TBS_V_BONDSDEALS'
   and r6.src_field_en_name = 'BUYORSELL'
   and r6.target_tab_en_name = 'AGT_BOND_TRAN'
   and r6.target_tab_field_en_name = 'TRAN_DIR_CD'
  left join ${iml_schema}.ref_pub_cd_map r3
    on p1.folderatts = r3.src_code_val
   and r3.sorc_sys_cd = 'CTMS'
   and r3.src_tab_en_name = 'CTMS_TBS_V_BONDSDEALS'
   and r3.src_field_en_name = 'FOLDERATTS'
   and r3.target_tab_en_name = 'AGT_BOND_TRAN'
   and r3.target_tab_field_en_name = 'ACCT_B_ATTR_CD'
  left join ${iml_schema}.ref_pub_cd_map r7
    on p3.assettype_id = r7.src_code_val
   and r7.sorc_sys_cd = 'CTMS'
   and r7.src_tab_en_name = 'CTMS_TBS_VS_ASSETTYPE'
   and r7.src_field_en_name = 'ASSETTYPE_ID'
   and r7.target_tab_en_name = 'AGT_BOND_TRAN'
   and r7.target_tab_field_en_name = 'ASSET_CLS4_CD'
  left join ${iml_schema}.ref_pub_cd_map r5
    on p1.settletype = r5.src_code_val
   and r5.sorc_sys_cd = 'CTMS'
   and r5.src_tab_en_name = 'CTMS_TBS_V_BONDSDEALS'
   and r5.src_field_en_name = 'SETTLETYPE'
   and r5.target_tab_en_name = 'AGT_BOND_TRAN'
   and r5.target_tab_field_en_name = 'STL_WAY_CD'
  left join ${iml_schema}.ref_pub_cd_map r4
    on p1.source = r4.src_code_val
   and r4.sorc_sys_cd = 'CTMS'
   and r4.src_tab_en_name = 'CTMS_TBS_V_BONDSDEALS'
   and r4.src_field_en_name = 'SOURCE'
   and r4.target_tab_en_name = 'AGT_BOND_TRAN'
   and r4.target_tab_field_en_name = 'TRAN_SRC_CD'
 where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_bond_tran_ctmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_bond_tran_ctmsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,bus_table_name -- 业务表名称
    ,dept_id -- 部门编号
    ,bond_id -- 债券编号
    ,bond_name -- 债券名称
    ,bond_type_cd -- 债券类型代码
    ,std_prod_id -- 标准产品编号
    ,tran_id -- 交易编号
    ,tran_dt -- 交易日期
    ,dlvy_dt -- 交割日期
    ,tran_dir_cd -- 交易方向代码
    ,curr_cd -- 币种代码
    ,tran_net_price -- 交易净价
    ,tran_full_price -- 交易全价
    ,exp_yld_rat -- 到期收益率
    ,stl_amt -- 结算金额
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,acct_b_id -- 账簿编号
    ,acct_b_name -- 账簿名称
    ,acct_b_attr_cd -- 账簿属性代码
    ,asset_cls4_cd -- 资产四分类代码
    ,cntpty_name -- 交易对手名称
    ,cntpty_id -- 交易对手编号
    ,stl_way_cd -- 结算方式代码
    ,dealer_id -- 交易员编号
    ,dealer_name -- 交易员名称
    ,bag_id -- 成交编号
    ,comm_fee -- 手续费
    ,tax -- 税金
    ,comm -- 佣金
    ,cert_face_tot -- 券面总额
    ,acru_int_tot -- 应计利息总额
    ,cfets_tran_flg -- CFETS交易标志
    ,tran_src_cd -- 交易来源代码
    ,asset_type_cd -- 资产类型代码
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
    ,nvl(n.bond_id, o.bond_id) as bond_id -- 债券编号
    ,nvl(n.bond_name, o.bond_name) as bond_name -- 债券名称
    ,nvl(n.bond_type_cd, o.bond_type_cd) as bond_type_cd -- 债券类型代码
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,nvl(n.tran_id, o.tran_id) as tran_id -- 交易编号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.dlvy_dt, o.dlvy_dt) as dlvy_dt -- 交割日期
    ,nvl(n.tran_dir_cd, o.tran_dir_cd) as tran_dir_cd -- 交易方向代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.tran_net_price, o.tran_net_price) as tran_net_price -- 交易净价
    ,nvl(n.tran_full_price, o.tran_full_price) as tran_full_price -- 交易全价
    ,nvl(n.exp_yld_rat, o.exp_yld_rat) as exp_yld_rat -- 到期收益率
    ,nvl(n.stl_amt, o.stl_amt) as stl_amt -- 结算金额
    ,nvl(n.portf_id, o.portf_id) as portf_id -- 投组编号
    ,nvl(n.portf_name, o.portf_name) as portf_name -- 投组名称
    ,nvl(n.acct_b_id, o.acct_b_id) as acct_b_id -- 账簿编号
    ,nvl(n.acct_b_name, o.acct_b_name) as acct_b_name -- 账簿名称
    ,nvl(n.acct_b_attr_cd, o.acct_b_attr_cd) as acct_b_attr_cd -- 账簿属性代码
    ,nvl(n.asset_cls4_cd, o.asset_cls4_cd) as asset_cls4_cd -- 资产四分类代码
    ,nvl(n.cntpty_name, o.cntpty_name) as cntpty_name -- 交易对手名称
    ,nvl(n.cntpty_id, o.cntpty_id) as cntpty_id -- 交易对手编号
    ,nvl(n.stl_way_cd, o.stl_way_cd) as stl_way_cd -- 结算方式代码
    ,nvl(n.dealer_id, o.dealer_id) as dealer_id -- 交易员编号
    ,nvl(n.dealer_name, o.dealer_name) as dealer_name -- 交易员名称
    ,nvl(n.bag_id, o.bag_id) as bag_id -- 成交编号
    ,nvl(n.comm_fee, o.comm_fee) as comm_fee -- 手续费
    ,nvl(n.tax, o.tax) as tax -- 税金
    ,nvl(n.comm, o.comm) as comm -- 佣金
    ,nvl(n.cert_face_tot, o.cert_face_tot) as cert_face_tot -- 券面总额
    ,nvl(n.acru_int_tot, o.acru_int_tot) as acru_int_tot -- 应计利息总额
    ,nvl(n.cfets_tran_flg, o.cfets_tran_flg) as cfets_tran_flg -- CFETS交易标志
    ,nvl(n.tran_src_cd, o.tran_src_cd) as tran_src_cd -- 交易来源代码
    ,nvl(n.asset_type_cd, o.asset_type_cd) as asset_type_cd -- 资产类型代码
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
                or o.bond_id <> n.bond_id
                or o.bond_name <> n.bond_name
                or o.bond_type_cd <> n.bond_type_cd
                or o.std_prod_id <> n.std_prod_id
                or o.tran_id <> n.tran_id
                or o.tran_dt <> n.tran_dt
                or o.dlvy_dt <> n.dlvy_dt
                or o.tran_dir_cd <> n.tran_dir_cd
                or o.curr_cd <> n.curr_cd
                or o.tran_net_price <> n.tran_net_price
                or o.tran_full_price <> n.tran_full_price
                or o.exp_yld_rat <> n.exp_yld_rat
                or o.stl_amt <> n.stl_amt
                or o.portf_id <> n.portf_id
                or o.portf_name <> n.portf_name
                or o.acct_b_id <> n.acct_b_id
                or o.acct_b_name <> n.acct_b_name
                or o.acct_b_attr_cd <> n.acct_b_attr_cd
                or o.asset_cls4_cd <> n.asset_cls4_cd
                or o.cntpty_name <> n.cntpty_name
                or o.cntpty_id <> n.cntpty_id
                or o.stl_way_cd <> n.stl_way_cd
                or o.dealer_id <> n.dealer_id
                or o.dealer_name <> n.dealer_name
                or o.bag_id <> n.bag_id
                or o.comm_fee <> n.comm_fee
                or o.tax <> n.tax
                or o.comm <> n.comm
                or o.cert_face_tot <> n.cert_face_tot
                or o.acru_int_tot <> n.acru_int_tot
                or o.cfets_tran_flg <> n.cfets_tran_flg
                or o.tran_src_cd <> n.tran_src_cd
                or o.asset_type_cd <> n.asset_type_cd
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
from ${iml_schema}.agt_bond_tran_ctmsf1_tm n
    full join ${iml_schema}.agt_bond_tran_ctmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_bond_tran truncate partition for ('ctmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_bond_tran exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.agt_bond_tran_ctmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_bond_tran drop subpartition p_ctmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bond_tran to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_bond_tran_ctmsf1_tm purge;
drop table ${iml_schema}.agt_bond_tran_ctmsf1_ex purge;
drop table ${iml_schema}.agt_bond_tran_ctmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bond_tran', partname => 'p_ctmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);