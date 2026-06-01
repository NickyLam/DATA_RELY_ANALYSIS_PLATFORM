/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_dom_buyer_lc_h_isbsf1
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
alter table ${iml_schema}.agt_dom_buyer_lc_h add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dom_buyer_lc_h partition for ('isbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_op purge;
drop table ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_lc_id -- 内部信用证编号
    ,lc_id -- 信用证编号
    ,tran_descb -- 交易描述
    ,bus_teller_id -- 业务柜员编号
    ,sys_rgst_dt -- 系统登记日期
    ,issue_dt -- 开证日期
    ,close_dt -- 闭卷日期
    ,close_type_cd -- 闭卷类型代码
    ,advise_bank_name -- 通知行名称
    ,final_modif_dt -- 最后修改日期
    ,modif_cnt -- 修改次数
    ,applit_name -- 申请人名称
    ,applit_ref_id -- 申请人参考编号
    ,pay_way_cd -- 付款方式代码
    ,benefc_name -- 受益人名称
    ,fee_src_cd -- 费用来源代码
    ,cfm_way_cd -- 保兑方式代码
    ,exp_dt -- 到期日期
    ,present_site -- 交单地点
    ,lc_type_cd -- 信用证类型代码
    ,m_l_way_cd -- 溢短装方式代码
    ,m_l_cu_ratio -- 溢短装上浮比例
    ,m_l_lower_ratio -- 溢短装下浮比例
    ,shipment_dt -- 装船日期
    ,shipment_site -- 装船地点
    ,acpt_cnt -- 承兑次数
    ,vp -- 有效期
    ,belong_org_id -- 所属机构编号
    ,trast_org_id -- 办理机构编号
    ,issue_way_cd -- 开证方式代码
    ,dubil_id -- 借据编号
    ,inpwn_type_cd -- 质押类型代码
    ,traff_way_cd -- 运输方式代码
    ,lc_bal -- 信用证余额
    ,open_way_cd -- 开立方式代码
    ,trade_type_cd -- 贸易类型代码
    ,cfm_flg -- 保兑标志
    ,pur_sale_cont_id -- 购销合同编号
    ,nego_pay_flg_cd -- 议付标志代码
    ,cont_curr_cd -- 合同币种代码
    ,cont_amt -- 合同金额
    ,prod_name -- 货品名称
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dom_buyer_lc_h partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dom_buyer_lc_h partition for ('isbsf1') where 0=1;

create table ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dom_buyer_lc_h partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_did-1
insert into ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_lc_id -- 内部信用证编号
    ,lc_id -- 信用证编号
    ,tran_descb -- 交易描述
    ,bus_teller_id -- 业务柜员编号
    ,sys_rgst_dt -- 系统登记日期
    ,issue_dt -- 开证日期
    ,close_dt -- 闭卷日期
    ,close_type_cd -- 闭卷类型代码
    ,advise_bank_name -- 通知行名称
    ,final_modif_dt -- 最后修改日期
    ,modif_cnt -- 修改次数
    ,applit_name -- 申请人名称
    ,applit_ref_id -- 申请人参考编号
    ,pay_way_cd -- 付款方式代码
    ,benefc_name -- 受益人名称
    ,fee_src_cd -- 费用来源代码
    ,cfm_way_cd -- 保兑方式代码
    ,exp_dt -- 到期日期
    ,present_site -- 交单地点
    ,lc_type_cd -- 信用证类型代码
    ,m_l_way_cd -- 溢短装方式代码
    ,m_l_cu_ratio -- 溢短装上浮比例
    ,m_l_lower_ratio -- 溢短装下浮比例
    ,shipment_dt -- 装船日期
    ,shipment_site -- 装船地点
    ,acpt_cnt -- 承兑次数
    ,vp -- 有效期
    ,belong_org_id -- 所属机构编号
    ,trast_org_id -- 办理机构编号
    ,issue_way_cd -- 开证方式代码
    ,dubil_id -- 借据编号
    ,inpwn_type_cd -- 质押类型代码
    ,traff_way_cd -- 运输方式代码
    ,lc_bal -- 信用证余额
    ,open_way_cd -- 开立方式代码
    ,trade_type_cd -- 贸易类型代码
    ,cfm_flg -- 保兑标志
    ,pur_sale_cont_id -- 购销合同编号
    ,nego_pay_flg_cd -- 议付标志代码
    ,cont_curr_cd -- 合同币种代码
    ,cont_amt -- 合同金额
    ,prod_name -- 货品名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222314'||P1.INR -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INR -- 内部信用证编号
    ,P1.OWNREF -- 信用证编号
    ,P1.NAM -- 交易描述
    ,P1.OWNUSR -- 业务柜员编号
    ,P1.CREDAT -- 系统登记日期
    ,P1.OPNDAT -- 开证日期
    ,P1.CLSDAT -- 闭卷日期
    ,nvl(trim(P1.CANTYP),'-') -- 闭卷类型代码
    ,P1.ADVNAM -- 通知行名称
    ,P1.AMEDAT -- 最后修改日期
    ,P1.AMENBR -- 修改次数
    ,P1.APLNAM -- 申请人名称
    ,P1.APLREF -- 申请人参考编号
    ,nvl(trim(P1.AVBBY),'-') -- 付款方式代码
    ,P1.BENNAM -- 受益人名称
    ,nvl(trim(P1.CHATO),'-') -- 费用来源代码
    ,nvl(trim(P1.CNFDET),'-') -- 保兑方式代码
    ,P1.EXPDAT -- 到期日期
    ,P1.EXPPLC -- 交单地点
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.LCRTYP END -- 信用证类型代码
    ,nvl(trim(P1.NOMSPC),'-') -- 溢短装方式代码
    ,P1.NOMTOP -- 溢短装上浮比例
    ,P1.NOMTON -- 溢短装下浮比例
    ,P1.SHPDAT -- 装船日期
    ,P1.SHPFRO -- 装船地点
    ,P1.UTLNBR -- 承兑次数
    ,P1.TENMAXDAY -- 有效期
    ,P2.BRANCH -- 所属机构编号
    ,P3.BRANCH -- 办理机构编号
    ,nvl(trim(P1.ISSTYP),'-') -- 开证方式代码
    ,P1.FINCOD -- 借据编号
    ,decode(P1.ZYTYP,' ','-','2','3','3','2',P1.ZYTYP) -- 质押类型代码
    ,nvl(trim(P1.TRATYP),'-') -- 运输方式代码
    ,P1.OPNAMO -- 信用证余额
    ,nvl(trim(P1.CRETYP),'-') -- 开立方式代码
    ,P1.TADTYP -- 贸易类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.COMFLG END -- 保兑标志
    ,P1.CONTRACTNO -- 购销合同编号
    ,nvl(trim(P1.NEGFLG),'-') -- 议付标志代码
    ,nvl(trim(P1.CONCUR),'-') -- 合同币种代码
    ,P1.CONAMT -- 合同金额
    ,P1.PRODUCTNAME -- 货品名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_did' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_did p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.LCRTYP = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ISBS'
        AND R1.SRC_TAB_EN_NAME= 'ISBS_DID'
        AND R1.SRC_FIELD_EN_NAME= 'LCRTYP'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_DOM_BUYER_LC_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'LC_TYPE_CD'
    left join ${iol_schema}.isbs_bch p2 on P1.BRANCHINR=p2.inr
and p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_bch p3 on P1.BCHKEYINR=p3.inr
and p3.start_dt <= to_date('${batch_date}','yyyymmdd') and p3.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.COMFLG = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ISBS'
        AND R2.SRC_TAB_EN_NAME= 'ISBS_DID'
        AND R2.SRC_FIELD_EN_NAME= 'COMFLG'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_DOM_BUYER_LC_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CFM_FLG'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_tm 
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_lc_id -- 内部信用证编号
    ,lc_id -- 信用证编号
    ,tran_descb -- 交易描述
    ,bus_teller_id -- 业务柜员编号
    ,sys_rgst_dt -- 系统登记日期
    ,issue_dt -- 开证日期
    ,close_dt -- 闭卷日期
    ,close_type_cd -- 闭卷类型代码
    ,advise_bank_name -- 通知行名称
    ,final_modif_dt -- 最后修改日期
    ,modif_cnt -- 修改次数
    ,applit_name -- 申请人名称
    ,applit_ref_id -- 申请人参考编号
    ,pay_way_cd -- 付款方式代码
    ,benefc_name -- 受益人名称
    ,fee_src_cd -- 费用来源代码
    ,cfm_way_cd -- 保兑方式代码
    ,exp_dt -- 到期日期
    ,present_site -- 交单地点
    ,lc_type_cd -- 信用证类型代码
    ,m_l_way_cd -- 溢短装方式代码
    ,m_l_cu_ratio -- 溢短装上浮比例
    ,m_l_lower_ratio -- 溢短装下浮比例
    ,shipment_dt -- 装船日期
    ,shipment_site -- 装船地点
    ,acpt_cnt -- 承兑次数
    ,vp -- 有效期
    ,belong_org_id -- 所属机构编号
    ,trast_org_id -- 办理机构编号
    ,issue_way_cd -- 开证方式代码
    ,dubil_id -- 借据编号
    ,inpwn_type_cd -- 质押类型代码
    ,traff_way_cd -- 运输方式代码
    ,lc_bal -- 信用证余额
    ,open_way_cd -- 开立方式代码
    ,trade_type_cd -- 贸易类型代码
    ,cfm_flg -- 保兑标志
    ,pur_sale_cont_id -- 购销合同编号
    ,nego_pay_flg_cd -- 议付标志代码
    ,cont_curr_cd -- 合同币种代码
    ,cont_amt -- 合同金额
    ,prod_name -- 货品名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_lc_id -- 内部信用证编号
    ,lc_id -- 信用证编号
    ,tran_descb -- 交易描述
    ,bus_teller_id -- 业务柜员编号
    ,sys_rgst_dt -- 系统登记日期
    ,issue_dt -- 开证日期
    ,close_dt -- 闭卷日期
    ,close_type_cd -- 闭卷类型代码
    ,advise_bank_name -- 通知行名称
    ,final_modif_dt -- 最后修改日期
    ,modif_cnt -- 修改次数
    ,applit_name -- 申请人名称
    ,applit_ref_id -- 申请人参考编号
    ,pay_way_cd -- 付款方式代码
    ,benefc_name -- 受益人名称
    ,fee_src_cd -- 费用来源代码
    ,cfm_way_cd -- 保兑方式代码
    ,exp_dt -- 到期日期
    ,present_site -- 交单地点
    ,lc_type_cd -- 信用证类型代码
    ,m_l_way_cd -- 溢短装方式代码
    ,m_l_cu_ratio -- 溢短装上浮比例
    ,m_l_lower_ratio -- 溢短装下浮比例
    ,shipment_dt -- 装船日期
    ,shipment_site -- 装船地点
    ,acpt_cnt -- 承兑次数
    ,vp -- 有效期
    ,belong_org_id -- 所属机构编号
    ,trast_org_id -- 办理机构编号
    ,issue_way_cd -- 开证方式代码
    ,dubil_id -- 借据编号
    ,inpwn_type_cd -- 质押类型代码
    ,traff_way_cd -- 运输方式代码
    ,lc_bal -- 信用证余额
    ,open_way_cd -- 开立方式代码
    ,trade_type_cd -- 贸易类型代码
    ,cfm_flg -- 保兑标志
    ,pur_sale_cont_id -- 购销合同编号
    ,nego_pay_flg_cd -- 议付标志代码
    ,cont_curr_cd -- 合同币种代码
    ,cont_amt -- 合同金额
    ,prod_name -- 货品名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.intnal_lc_id, o.intnal_lc_id) as intnal_lc_id -- 内部信用证编号
    ,nvl(n.lc_id, o.lc_id) as lc_id -- 信用证编号
    ,nvl(n.tran_descb, o.tran_descb) as tran_descb -- 交易描述
    ,nvl(n.bus_teller_id, o.bus_teller_id) as bus_teller_id -- 业务柜员编号
    ,nvl(n.sys_rgst_dt, o.sys_rgst_dt) as sys_rgst_dt -- 系统登记日期
    ,nvl(n.issue_dt, o.issue_dt) as issue_dt -- 开证日期
    ,nvl(n.close_dt, o.close_dt) as close_dt -- 闭卷日期
    ,nvl(n.close_type_cd, o.close_type_cd) as close_type_cd -- 闭卷类型代码
    ,nvl(n.advise_bank_name, o.advise_bank_name) as advise_bank_name -- 通知行名称
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,nvl(n.modif_cnt, o.modif_cnt) as modif_cnt -- 修改次数
    ,nvl(n.applit_name, o.applit_name) as applit_name -- 申请人名称
    ,nvl(n.applit_ref_id, o.applit_ref_id) as applit_ref_id -- 申请人参考编号
    ,nvl(n.pay_way_cd, o.pay_way_cd) as pay_way_cd -- 付款方式代码
    ,nvl(n.benefc_name, o.benefc_name) as benefc_name -- 受益人名称
    ,nvl(n.fee_src_cd, o.fee_src_cd) as fee_src_cd -- 费用来源代码
    ,nvl(n.cfm_way_cd, o.cfm_way_cd) as cfm_way_cd -- 保兑方式代码
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.present_site, o.present_site) as present_site -- 交单地点
    ,nvl(n.lc_type_cd, o.lc_type_cd) as lc_type_cd -- 信用证类型代码
    ,nvl(n.m_l_way_cd, o.m_l_way_cd) as m_l_way_cd -- 溢短装方式代码
    ,nvl(n.m_l_cu_ratio, o.m_l_cu_ratio) as m_l_cu_ratio -- 溢短装上浮比例
    ,nvl(n.m_l_lower_ratio, o.m_l_lower_ratio) as m_l_lower_ratio -- 溢短装下浮比例
    ,nvl(n.shipment_dt, o.shipment_dt) as shipment_dt -- 装船日期
    ,nvl(n.shipment_site, o.shipment_site) as shipment_site -- 装船地点
    ,nvl(n.acpt_cnt, o.acpt_cnt) as acpt_cnt -- 承兑次数
    ,nvl(n.vp, o.vp) as vp -- 有效期
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.trast_org_id, o.trast_org_id) as trast_org_id -- 办理机构编号
    ,nvl(n.issue_way_cd, o.issue_way_cd) as issue_way_cd -- 开证方式代码
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.inpwn_type_cd, o.inpwn_type_cd) as inpwn_type_cd -- 质押类型代码
    ,nvl(n.traff_way_cd, o.traff_way_cd) as traff_way_cd -- 运输方式代码
    ,nvl(n.lc_bal, o.lc_bal) as lc_bal -- 信用证余额
    ,nvl(n.open_way_cd, o.open_way_cd) as open_way_cd -- 开立方式代码
    ,nvl(n.trade_type_cd, o.trade_type_cd) as trade_type_cd -- 贸易类型代码
    ,nvl(n.cfm_flg, o.cfm_flg) as cfm_flg -- 保兑标志
    ,nvl(n.pur_sale_cont_id, o.pur_sale_cont_id) as pur_sale_cont_id -- 购销合同编号
    ,nvl(n.nego_pay_flg_cd, o.nego_pay_flg_cd) as nego_pay_flg_cd -- 议付标志代码
    ,nvl(n.cont_curr_cd, o.cont_curr_cd) as cont_curr_cd -- 合同币种代码
    ,nvl(n.cont_amt, o.cont_amt) as cont_amt -- 合同金额
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 货品名称
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_tm n
    full join (select * from ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.intnal_lc_id <> n.intnal_lc_id
        or o.lc_id <> n.lc_id
        or o.tran_descb <> n.tran_descb
        or o.bus_teller_id <> n.bus_teller_id
        or o.sys_rgst_dt <> n.sys_rgst_dt
        or o.issue_dt <> n.issue_dt
        or o.close_dt <> n.close_dt
        or o.close_type_cd <> n.close_type_cd
        or o.advise_bank_name <> n.advise_bank_name
        or o.final_modif_dt <> n.final_modif_dt
        or o.modif_cnt <> n.modif_cnt
        or o.applit_name <> n.applit_name
        or o.applit_ref_id <> n.applit_ref_id
        or o.pay_way_cd <> n.pay_way_cd
        or o.benefc_name <> n.benefc_name
        or o.fee_src_cd <> n.fee_src_cd
        or o.cfm_way_cd <> n.cfm_way_cd
        or o.exp_dt <> n.exp_dt
        or o.present_site <> n.present_site
        or o.lc_type_cd <> n.lc_type_cd
        or o.m_l_way_cd <> n.m_l_way_cd
        or o.m_l_cu_ratio <> n.m_l_cu_ratio
        or o.m_l_lower_ratio <> n.m_l_lower_ratio
        or o.shipment_dt <> n.shipment_dt
        or o.shipment_site <> n.shipment_site
        or o.acpt_cnt <> n.acpt_cnt
        or o.vp <> n.vp
        or o.belong_org_id <> n.belong_org_id
        or o.trast_org_id <> n.trast_org_id
        or o.issue_way_cd <> n.issue_way_cd
        or o.dubil_id <> n.dubil_id
        or o.inpwn_type_cd <> n.inpwn_type_cd
        or o.traff_way_cd <> n.traff_way_cd
        or o.lc_bal <> n.lc_bal
        or o.open_way_cd <> n.open_way_cd
        or o.trade_type_cd <> n.trade_type_cd
        or o.cfm_flg <> n.cfm_flg
        or o.pur_sale_cont_id <> n.pur_sale_cont_id
        or o.nego_pay_flg_cd <> n.nego_pay_flg_cd
        or o.cont_curr_cd <> n.cont_curr_cd
        or o.cont_amt <> n.cont_amt
        or o.prod_name <> n.prod_name
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_lc_id -- 内部信用证编号
    ,lc_id -- 信用证编号
    ,tran_descb -- 交易描述
    ,bus_teller_id -- 业务柜员编号
    ,sys_rgst_dt -- 系统登记日期
    ,issue_dt -- 开证日期
    ,close_dt -- 闭卷日期
    ,close_type_cd -- 闭卷类型代码
    ,advise_bank_name -- 通知行名称
    ,final_modif_dt -- 最后修改日期
    ,modif_cnt -- 修改次数
    ,applit_name -- 申请人名称
    ,applit_ref_id -- 申请人参考编号
    ,pay_way_cd -- 付款方式代码
    ,benefc_name -- 受益人名称
    ,fee_src_cd -- 费用来源代码
    ,cfm_way_cd -- 保兑方式代码
    ,exp_dt -- 到期日期
    ,present_site -- 交单地点
    ,lc_type_cd -- 信用证类型代码
    ,m_l_way_cd -- 溢短装方式代码
    ,m_l_cu_ratio -- 溢短装上浮比例
    ,m_l_lower_ratio -- 溢短装下浮比例
    ,shipment_dt -- 装船日期
    ,shipment_site -- 装船地点
    ,acpt_cnt -- 承兑次数
    ,vp -- 有效期
    ,belong_org_id -- 所属机构编号
    ,trast_org_id -- 办理机构编号
    ,issue_way_cd -- 开证方式代码
    ,dubil_id -- 借据编号
    ,inpwn_type_cd -- 质押类型代码
    ,traff_way_cd -- 运输方式代码
    ,lc_bal -- 信用证余额
    ,open_way_cd -- 开立方式代码
    ,trade_type_cd -- 贸易类型代码
    ,cfm_flg -- 保兑标志
    ,pur_sale_cont_id -- 购销合同编号
    ,nego_pay_flg_cd -- 议付标志代码
    ,cont_curr_cd -- 合同币种代码
    ,cont_amt -- 合同金额
    ,prod_name -- 货品名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_lc_id -- 内部信用证编号
    ,lc_id -- 信用证编号
    ,tran_descb -- 交易描述
    ,bus_teller_id -- 业务柜员编号
    ,sys_rgst_dt -- 系统登记日期
    ,issue_dt -- 开证日期
    ,close_dt -- 闭卷日期
    ,close_type_cd -- 闭卷类型代码
    ,advise_bank_name -- 通知行名称
    ,final_modif_dt -- 最后修改日期
    ,modif_cnt -- 修改次数
    ,applit_name -- 申请人名称
    ,applit_ref_id -- 申请人参考编号
    ,pay_way_cd -- 付款方式代码
    ,benefc_name -- 受益人名称
    ,fee_src_cd -- 费用来源代码
    ,cfm_way_cd -- 保兑方式代码
    ,exp_dt -- 到期日期
    ,present_site -- 交单地点
    ,lc_type_cd -- 信用证类型代码
    ,m_l_way_cd -- 溢短装方式代码
    ,m_l_cu_ratio -- 溢短装上浮比例
    ,m_l_lower_ratio -- 溢短装下浮比例
    ,shipment_dt -- 装船日期
    ,shipment_site -- 装船地点
    ,acpt_cnt -- 承兑次数
    ,vp -- 有效期
    ,belong_org_id -- 所属机构编号
    ,trast_org_id -- 办理机构编号
    ,issue_way_cd -- 开证方式代码
    ,dubil_id -- 借据编号
    ,inpwn_type_cd -- 质押类型代码
    ,traff_way_cd -- 运输方式代码
    ,lc_bal -- 信用证余额
    ,open_way_cd -- 开立方式代码
    ,trade_type_cd -- 贸易类型代码
    ,cfm_flg -- 保兑标志
    ,pur_sale_cont_id -- 购销合同编号
    ,nego_pay_flg_cd -- 议付标志代码
    ,cont_curr_cd -- 合同币种代码
    ,cont_amt -- 合同金额
    ,prod_name -- 货品名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.intnal_lc_id -- 内部信用证编号
    ,o.lc_id -- 信用证编号
    ,o.tran_descb -- 交易描述
    ,o.bus_teller_id -- 业务柜员编号
    ,o.sys_rgst_dt -- 系统登记日期
    ,o.issue_dt -- 开证日期
    ,o.close_dt -- 闭卷日期
    ,o.close_type_cd -- 闭卷类型代码
    ,o.advise_bank_name -- 通知行名称
    ,o.final_modif_dt -- 最后修改日期
    ,o.modif_cnt -- 修改次数
    ,o.applit_name -- 申请人名称
    ,o.applit_ref_id -- 申请人参考编号
    ,o.pay_way_cd -- 付款方式代码
    ,o.benefc_name -- 受益人名称
    ,o.fee_src_cd -- 费用来源代码
    ,o.cfm_way_cd -- 保兑方式代码
    ,o.exp_dt -- 到期日期
    ,o.present_site -- 交单地点
    ,o.lc_type_cd -- 信用证类型代码
    ,o.m_l_way_cd -- 溢短装方式代码
    ,o.m_l_cu_ratio -- 溢短装上浮比例
    ,o.m_l_lower_ratio -- 溢短装下浮比例
    ,o.shipment_dt -- 装船日期
    ,o.shipment_site -- 装船地点
    ,o.acpt_cnt -- 承兑次数
    ,o.vp -- 有效期
    ,o.belong_org_id -- 所属机构编号
    ,o.trast_org_id -- 办理机构编号
    ,o.issue_way_cd -- 开证方式代码
    ,o.dubil_id -- 借据编号
    ,o.inpwn_type_cd -- 质押类型代码
    ,o.traff_way_cd -- 运输方式代码
    ,o.lc_bal -- 信用证余额
    ,o.open_way_cd -- 开立方式代码
    ,o.trade_type_cd -- 贸易类型代码
    ,o.cfm_flg -- 保兑标志
    ,o.pur_sale_cont_id -- 购销合同编号
    ,o.nego_pay_flg_cd -- 议付标志代码
    ,o.cont_curr_cd -- 合同币种代码
    ,o.cont_amt -- 合同金额
    ,o.prod_name -- 货品名称
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
from ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_bk o
    left join ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_dom_buyer_lc_h;
--alter table ${iml_schema}.agt_dom_buyer_lc_h truncate partition for ('isbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_dom_buyer_lc_h') 
               and substr(subpartition_name,1,8)=upper('p_isbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_dom_buyer_lc_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_dom_buyer_lc_h modify partition p_isbsf1 
add subpartition p_isbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_dom_buyer_lc_h exchange subpartition p_isbsf1_${batch_date} with table ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_cl;
alter table ${iml_schema}.agt_dom_buyer_lc_h exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_dom_buyer_lc_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_op purge;
drop table ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_dom_buyer_lc_h_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_dom_buyer_lc_h', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
