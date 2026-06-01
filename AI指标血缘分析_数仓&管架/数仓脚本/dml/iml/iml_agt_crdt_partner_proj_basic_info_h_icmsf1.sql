/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_crdt_partner_proj_basic_info_h_icmsf1
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
alter table ${iml_schema}.agt_crdt_partner_proj_basic_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_crdt_partner_proj_basic_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,co_proj_id -- 合作项目编号
    ,co_proj_name -- 合作项目名称
    ,co_proj_type_cd -- 合作项目类型代码
    ,partner_id -- 合作方编号
    ,partner_type_cd -- 合作方类型代码
    ,coprator_type_cd -- 合作商类型代码
    ,partner_capital_ratio -- 合作方资本金比例
    ,co_agt_id -- 合作协议编号
    ,have_proj_lmt_flg -- 有项目额度标志
    ,proj_begin_dt -- 项目起始日期
    ,proj_exp_dt -- 项目到期日期
    ,co_tenor -- 合作期限
    ,fee_rat -- 费率
    ,comm_ratio -- 佣金比例
    ,proj_status_cd -- 项目状态代码
    ,proj_descb -- 项目描述
    ,cont_circl_flg -- 合同可循环标志
    ,org_id -- 机构编号
    ,cap_supv_acct_id -- 资金监管账户编号
    ,cap_supv_acct_name -- 资金监管账户名称
    ,proj_stl_acct_id -- 项目结算账户编号
    ,proj_stl_acct_name -- 项目结算账户名称
    ,proj_stl_open_acct_bank_org_id -- 项目结算开户银行机构编号
    ,proj_stl_open_acct_org_id -- 项目结算开户机构编号
    ,appl_type_cd -- 申请类型代码
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,move_remark -- 迁移备注
    ,cmplt_flg -- 完成标志
    ,final_update_dt -- 最后更新日期
    ,proj_intror_name -- 项目介绍人名称
    ,fit_org_range_cd -- 适用机构范围代码
    ,expt_lmt_flg -- 例外额度标志
    ,paid_in_capital -- 实收资本
    ,co_mode_cd -- 合作模式代码
    ,init_agt_id -- 原协议编号
    ,bus_max_open_amt -- 业务最大敞口金额
    ,rgst_cap -- 注册资本
    ,early_days_start_use_lmt -- 前期启用额度
    ,lmt_nmal_amt -- 额度名义金额
    ,circl_flg -- 循环标志
    ,invo_syn_crdt_apv_reply_modif_flg -- 涉及综合信贷审批批复变更标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_crdt_partner_proj_basic_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_crdt_partner_proj_basic_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_crdt_partner_proj_basic_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_partner_project_info-1
insert into ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,co_proj_id -- 合作项目编号
    ,co_proj_name -- 合作项目名称
    ,co_proj_type_cd -- 合作项目类型代码
    ,partner_id -- 合作方编号
    ,partner_type_cd -- 合作方类型代码
    ,coprator_type_cd -- 合作商类型代码
    ,partner_capital_ratio -- 合作方资本金比例
    ,co_agt_id -- 合作协议编号
    ,have_proj_lmt_flg -- 有项目额度标志
    ,proj_begin_dt -- 项目起始日期
    ,proj_exp_dt -- 项目到期日期
    ,co_tenor -- 合作期限
    ,fee_rat -- 费率
    ,comm_ratio -- 佣金比例
    ,proj_status_cd -- 项目状态代码
    ,proj_descb -- 项目描述
    ,cont_circl_flg -- 合同可循环标志
    ,org_id -- 机构编号
    ,cap_supv_acct_id -- 资金监管账户编号
    ,cap_supv_acct_name -- 资金监管账户名称
    ,proj_stl_acct_id -- 项目结算账户编号
    ,proj_stl_acct_name -- 项目结算账户名称
    ,proj_stl_open_acct_bank_org_id -- 项目结算开户银行机构编号
    ,proj_stl_open_acct_org_id -- 项目结算开户机构编号
    ,appl_type_cd -- 申请类型代码
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,move_remark -- 迁移备注
    ,cmplt_flg -- 完成标志
    ,final_update_dt -- 最后更新日期
    ,proj_intror_name -- 项目介绍人名称
    ,fit_org_range_cd -- 适用机构范围代码
    ,expt_lmt_flg -- 例外额度标志
    ,paid_in_capital -- 实收资本
    ,co_mode_cd -- 合作模式代码
    ,init_agt_id -- 原协议编号
    ,bus_max_open_amt -- 业务最大敞口金额
    ,rgst_cap -- 注册资本
    ,early_days_start_use_lmt -- 前期启用额度
    ,lmt_nmal_amt -- 额度名义金额
    ,circl_flg -- 循环标志
    ,invo_syn_crdt_apv_reply_modif_flg -- 涉及综合信贷审批批复变更标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300018'||P1.PROJECTNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.PROJECTNO -- 合作项目编号
    ,P1.PROJECTNAMEC -- 合作项目名称
    ,NVL(TRIM(P1.PROJECTTYPE),'-') -- 合作项目类型代码
    ,P1.PARTNERID -- 合作方编号
    ,nvl(trim(P1.PARTNERTYPE),'-') -- 合作方类型代码
    ,nvl(trim(P1.PARTNERTYPESUB),'-')  -- 合作商类型代码
    ,P1.CAPITALRATIO -- 合作方资本金比例
    ,P1.AGREEMENTNO -- 合作协议编号
    ,nvl(trim(P1.PROJECTLIMITTYPE),'-') -- 有项目额度标志
    ,P1.STARTDATE -- 项目起始日期
    ,P1.EXPIRYDATE -- 项目到期日期
    ,P1.COOPTERM -- 合作期限
    ,P1.COSTPROP -- 费率
    ,P1.COMMISSIONRATIO -- 佣金比例
    ,P1.STATUS -- 项目状态代码
    ,P1.PROJECTDESCRIBE -- 项目描述
    ,P1.PARTNERSUMTYPE -- 合同可循环标志
    ,P1.AGENCYNO -- 机构编号
    ,P1.FUNDMGRACCNO -- 资金监管账户编号
    ,P1.FUNDMGRACCNAME -- 资金监管账户名称
    ,P1.PRJACCNO -- 项目结算账户编号
    ,P1.PRJACCNAME -- 项目结算账户名称
    ,P1.PRJACCBANK -- 项目结算开户银行机构编号
    ,P1.PRJACCORG -- 项目结算开户机构编号
    ,nvl(trim(P1.APPLYTYPE),'-') -- 申请类型代码
    ,P1.ISBANKREL -- 我行关联人标志
    ,P1.MIGTFLAG -- 迁移备注
    ,nvl(trim(P1.COMPLETEFLAG),'-') -- 完成标志
    ,P1.UPDATEDATE -- 最后更新日期
    ,P1.PRJINTRODUCER -- 项目介绍人名称
    ,decode(P1.ORGRANGE,' ','-','01','13','02','11','03','10',P1.ORGRANGE) -- 适用机构范围代码
    ,nvl(trim(P1.ISEXCEPTION),'-') -- 例外额度标志
    ,P1.PAICLUPCAPITAL -- 实收资本
    ,nvl(trim(P1.COOPPATTERN),'-') -- 合作模式代码
    ,P1.OLDCONTRACTNO -- 原协议编号
    ,P1.TOTALSUM -- 业务最大敞口金额
    ,P1.REGISTERCAPITAL -- 注册资本
    ,P1.FIRSTUSESUM -- 前期启用额度
    ,P1.NOMINALSUM -- 额度名义金额
    ,nvl(trim(P1.ISLOOP),'-') -- 循环标志
    ,nvl(trim(P1.ISINVOLVE),'-') -- 涉及综合信贷审批批复变更标志
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_partner_project_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_partner_project_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,co_proj_id
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
        into ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,co_proj_id -- 合作项目编号
    ,co_proj_name -- 合作项目名称
    ,co_proj_type_cd -- 合作项目类型代码
    ,partner_id -- 合作方编号
    ,partner_type_cd -- 合作方类型代码
    ,coprator_type_cd -- 合作商类型代码
    ,partner_capital_ratio -- 合作方资本金比例
    ,co_agt_id -- 合作协议编号
    ,have_proj_lmt_flg -- 有项目额度标志
    ,proj_begin_dt -- 项目起始日期
    ,proj_exp_dt -- 项目到期日期
    ,co_tenor -- 合作期限
    ,fee_rat -- 费率
    ,comm_ratio -- 佣金比例
    ,proj_status_cd -- 项目状态代码
    ,proj_descb -- 项目描述
    ,cont_circl_flg -- 合同可循环标志
    ,org_id -- 机构编号
    ,cap_supv_acct_id -- 资金监管账户编号
    ,cap_supv_acct_name -- 资金监管账户名称
    ,proj_stl_acct_id -- 项目结算账户编号
    ,proj_stl_acct_name -- 项目结算账户名称
    ,proj_stl_open_acct_bank_org_id -- 项目结算开户银行机构编号
    ,proj_stl_open_acct_org_id -- 项目结算开户机构编号
    ,appl_type_cd -- 申请类型代码
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,move_remark -- 迁移备注
    ,cmplt_flg -- 完成标志
    ,final_update_dt -- 最后更新日期
    ,proj_intror_name -- 项目介绍人名称
    ,fit_org_range_cd -- 适用机构范围代码
    ,expt_lmt_flg -- 例外额度标志
    ,paid_in_capital -- 实收资本
    ,co_mode_cd -- 合作模式代码
    ,init_agt_id -- 原协议编号
    ,bus_max_open_amt -- 业务最大敞口金额
    ,rgst_cap -- 注册资本
    ,early_days_start_use_lmt -- 前期启用额度
    ,lmt_nmal_amt -- 额度名义金额
    ,circl_flg -- 循环标志
    ,invo_syn_crdt_apv_reply_modif_flg -- 涉及综合信贷审批批复变更标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,co_proj_id -- 合作项目编号
    ,co_proj_name -- 合作项目名称
    ,co_proj_type_cd -- 合作项目类型代码
    ,partner_id -- 合作方编号
    ,partner_type_cd -- 合作方类型代码
    ,coprator_type_cd -- 合作商类型代码
    ,partner_capital_ratio -- 合作方资本金比例
    ,co_agt_id -- 合作协议编号
    ,have_proj_lmt_flg -- 有项目额度标志
    ,proj_begin_dt -- 项目起始日期
    ,proj_exp_dt -- 项目到期日期
    ,co_tenor -- 合作期限
    ,fee_rat -- 费率
    ,comm_ratio -- 佣金比例
    ,proj_status_cd -- 项目状态代码
    ,proj_descb -- 项目描述
    ,cont_circl_flg -- 合同可循环标志
    ,org_id -- 机构编号
    ,cap_supv_acct_id -- 资金监管账户编号
    ,cap_supv_acct_name -- 资金监管账户名称
    ,proj_stl_acct_id -- 项目结算账户编号
    ,proj_stl_acct_name -- 项目结算账户名称
    ,proj_stl_open_acct_bank_org_id -- 项目结算开户银行机构编号
    ,proj_stl_open_acct_org_id -- 项目结算开户机构编号
    ,appl_type_cd -- 申请类型代码
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,move_remark -- 迁移备注
    ,cmplt_flg -- 完成标志
    ,final_update_dt -- 最后更新日期
    ,proj_intror_name -- 项目介绍人名称
    ,fit_org_range_cd -- 适用机构范围代码
    ,expt_lmt_flg -- 例外额度标志
    ,paid_in_capital -- 实收资本
    ,co_mode_cd -- 合作模式代码
    ,init_agt_id -- 原协议编号
    ,bus_max_open_amt -- 业务最大敞口金额
    ,rgst_cap -- 注册资本
    ,early_days_start_use_lmt -- 前期启用额度
    ,lmt_nmal_amt -- 额度名义金额
    ,circl_flg -- 循环标志
    ,invo_syn_crdt_apv_reply_modif_flg -- 涉及综合信贷审批批复变更标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
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
    ,nvl(n.co_proj_id, o.co_proj_id) as co_proj_id -- 合作项目编号
    ,nvl(n.co_proj_name, o.co_proj_name) as co_proj_name -- 合作项目名称
    ,nvl(n.co_proj_type_cd, o.co_proj_type_cd) as co_proj_type_cd -- 合作项目类型代码
    ,nvl(n.partner_id, o.partner_id) as partner_id -- 合作方编号
    ,nvl(n.partner_type_cd, o.partner_type_cd) as partner_type_cd -- 合作方类型代码
    ,nvl(n.coprator_type_cd, o.coprator_type_cd) as coprator_type_cd -- 合作商类型代码
    ,nvl(n.partner_capital_ratio, o.partner_capital_ratio) as partner_capital_ratio -- 合作方资本金比例
    ,nvl(n.co_agt_id, o.co_agt_id) as co_agt_id -- 合作协议编号
    ,nvl(n.have_proj_lmt_flg, o.have_proj_lmt_flg) as have_proj_lmt_flg -- 有项目额度标志
    ,nvl(n.proj_begin_dt, o.proj_begin_dt) as proj_begin_dt -- 项目起始日期
    ,nvl(n.proj_exp_dt, o.proj_exp_dt) as proj_exp_dt -- 项目到期日期
    ,nvl(n.co_tenor, o.co_tenor) as co_tenor -- 合作期限
    ,nvl(n.fee_rat, o.fee_rat) as fee_rat -- 费率
    ,nvl(n.comm_ratio, o.comm_ratio) as comm_ratio -- 佣金比例
    ,nvl(n.proj_status_cd, o.proj_status_cd) as proj_status_cd -- 项目状态代码
    ,nvl(n.proj_descb, o.proj_descb) as proj_descb -- 项目描述
    ,nvl(n.cont_circl_flg, o.cont_circl_flg) as cont_circl_flg -- 合同可循环标志
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.cap_supv_acct_id, o.cap_supv_acct_id) as cap_supv_acct_id -- 资金监管账户编号
    ,nvl(n.cap_supv_acct_name, o.cap_supv_acct_name) as cap_supv_acct_name -- 资金监管账户名称
    ,nvl(n.proj_stl_acct_id, o.proj_stl_acct_id) as proj_stl_acct_id -- 项目结算账户编号
    ,nvl(n.proj_stl_acct_name, o.proj_stl_acct_name) as proj_stl_acct_name -- 项目结算账户名称
    ,nvl(n.proj_stl_open_acct_bank_org_id, o.proj_stl_open_acct_bank_org_id) as proj_stl_open_acct_bank_org_id -- 项目结算开户银行机构编号
    ,nvl(n.proj_stl_open_acct_org_id, o.proj_stl_open_acct_org_id) as proj_stl_open_acct_org_id -- 项目结算开户机构编号
    ,nvl(n.appl_type_cd, o.appl_type_cd) as appl_type_cd -- 申请类型代码
    ,nvl(n.hxb_rela_ps_flg, o.hxb_rela_ps_flg) as hxb_rela_ps_flg -- 我行关联人标志
    ,nvl(n.move_remark, o.move_remark) as move_remark -- 迁移备注
    ,nvl(n.cmplt_flg, o.cmplt_flg) as cmplt_flg -- 完成标志
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,nvl(n.proj_intror_name, o.proj_intror_name) as proj_intror_name -- 项目介绍人名称
    ,nvl(n.fit_org_range_cd, o.fit_org_range_cd) as fit_org_range_cd -- 适用机构范围代码
    ,nvl(n.expt_lmt_flg, o.expt_lmt_flg) as expt_lmt_flg -- 例外额度标志
    ,nvl(n.paid_in_capital, o.paid_in_capital) as paid_in_capital -- 实收资本
    ,nvl(n.co_mode_cd, o.co_mode_cd) as co_mode_cd -- 合作模式代码
    ,nvl(n.init_agt_id, o.init_agt_id) as init_agt_id -- 原协议编号
    ,nvl(n.bus_max_open_amt, o.bus_max_open_amt) as bus_max_open_amt -- 业务最大敞口金额
    ,nvl(n.rgst_cap, o.rgst_cap) as rgst_cap -- 注册资本
    ,nvl(n.early_days_start_use_lmt, o.early_days_start_use_lmt) as early_days_start_use_lmt -- 前期启用额度
    ,nvl(n.lmt_nmal_amt, o.lmt_nmal_amt) as lmt_nmal_amt -- 额度名义金额
    ,nvl(n.circl_flg, o.circl_flg) as circl_flg -- 循环标志
    ,nvl(n.invo_syn_crdt_apv_reply_modif_flg, o.invo_syn_crdt_apv_reply_modif_flg) as invo_syn_crdt_apv_reply_modif_flg -- 涉及综合信贷审批批复变更标志
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.co_proj_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.co_proj_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.co_proj_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.co_proj_id = n.co_proj_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.co_proj_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.co_proj_id is null
    )
    or (
        o.co_proj_name <> n.co_proj_name
        or o.co_proj_type_cd <> n.co_proj_type_cd
        or o.partner_id <> n.partner_id
        or o.partner_type_cd <> n.partner_type_cd
        or o.coprator_type_cd <> n.coprator_type_cd
        or o.partner_capital_ratio <> n.partner_capital_ratio
        or o.co_agt_id <> n.co_agt_id
        or o.have_proj_lmt_flg <> n.have_proj_lmt_flg
        or o.proj_begin_dt <> n.proj_begin_dt
        or o.proj_exp_dt <> n.proj_exp_dt
        or o.co_tenor <> n.co_tenor
        or o.fee_rat <> n.fee_rat
        or o.comm_ratio <> n.comm_ratio
        or o.proj_status_cd <> n.proj_status_cd
        or o.proj_descb <> n.proj_descb
        or o.cont_circl_flg <> n.cont_circl_flg
        or o.org_id <> n.org_id
        or o.cap_supv_acct_id <> n.cap_supv_acct_id
        or o.cap_supv_acct_name <> n.cap_supv_acct_name
        or o.proj_stl_acct_id <> n.proj_stl_acct_id
        or o.proj_stl_acct_name <> n.proj_stl_acct_name
        or o.proj_stl_open_acct_bank_org_id <> n.proj_stl_open_acct_bank_org_id
        or o.proj_stl_open_acct_org_id <> n.proj_stl_open_acct_org_id
        or o.appl_type_cd <> n.appl_type_cd
        or o.hxb_rela_ps_flg <> n.hxb_rela_ps_flg
        or o.move_remark <> n.move_remark
        or o.cmplt_flg <> n.cmplt_flg
        or o.final_update_dt <> n.final_update_dt
        or o.proj_intror_name <> n.proj_intror_name
        or o.fit_org_range_cd <> n.fit_org_range_cd
        or o.expt_lmt_flg <> n.expt_lmt_flg
        or o.paid_in_capital <> n.paid_in_capital
        or o.co_mode_cd <> n.co_mode_cd
        or o.init_agt_id <> n.init_agt_id
        or o.bus_max_open_amt <> n.bus_max_open_amt
        or o.rgst_cap <> n.rgst_cap
        or o.early_days_start_use_lmt <> n.early_days_start_use_lmt
        or o.lmt_nmal_amt <> n.lmt_nmal_amt
        or o.circl_flg <> n.circl_flg
        or o.invo_syn_crdt_apv_reply_modif_flg <> n.invo_syn_crdt_apv_reply_modif_flg
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,co_proj_id -- 合作项目编号
    ,co_proj_name -- 合作项目名称
    ,co_proj_type_cd -- 合作项目类型代码
    ,partner_id -- 合作方编号
    ,partner_type_cd -- 合作方类型代码
    ,coprator_type_cd -- 合作商类型代码
    ,partner_capital_ratio -- 合作方资本金比例
    ,co_agt_id -- 合作协议编号
    ,have_proj_lmt_flg -- 有项目额度标志
    ,proj_begin_dt -- 项目起始日期
    ,proj_exp_dt -- 项目到期日期
    ,co_tenor -- 合作期限
    ,fee_rat -- 费率
    ,comm_ratio -- 佣金比例
    ,proj_status_cd -- 项目状态代码
    ,proj_descb -- 项目描述
    ,cont_circl_flg -- 合同可循环标志
    ,org_id -- 机构编号
    ,cap_supv_acct_id -- 资金监管账户编号
    ,cap_supv_acct_name -- 资金监管账户名称
    ,proj_stl_acct_id -- 项目结算账户编号
    ,proj_stl_acct_name -- 项目结算账户名称
    ,proj_stl_open_acct_bank_org_id -- 项目结算开户银行机构编号
    ,proj_stl_open_acct_org_id -- 项目结算开户机构编号
    ,appl_type_cd -- 申请类型代码
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,move_remark -- 迁移备注
    ,cmplt_flg -- 完成标志
    ,final_update_dt -- 最后更新日期
    ,proj_intror_name -- 项目介绍人名称
    ,fit_org_range_cd -- 适用机构范围代码
    ,expt_lmt_flg -- 例外额度标志
    ,paid_in_capital -- 实收资本
    ,co_mode_cd -- 合作模式代码
    ,init_agt_id -- 原协议编号
    ,bus_max_open_amt -- 业务最大敞口金额
    ,rgst_cap -- 注册资本
    ,early_days_start_use_lmt -- 前期启用额度
    ,lmt_nmal_amt -- 额度名义金额
    ,circl_flg -- 循环标志
    ,invo_syn_crdt_apv_reply_modif_flg -- 涉及综合信贷审批批复变更标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,co_proj_id -- 合作项目编号
    ,co_proj_name -- 合作项目名称
    ,co_proj_type_cd -- 合作项目类型代码
    ,partner_id -- 合作方编号
    ,partner_type_cd -- 合作方类型代码
    ,coprator_type_cd -- 合作商类型代码
    ,partner_capital_ratio -- 合作方资本金比例
    ,co_agt_id -- 合作协议编号
    ,have_proj_lmt_flg -- 有项目额度标志
    ,proj_begin_dt -- 项目起始日期
    ,proj_exp_dt -- 项目到期日期
    ,co_tenor -- 合作期限
    ,fee_rat -- 费率
    ,comm_ratio -- 佣金比例
    ,proj_status_cd -- 项目状态代码
    ,proj_descb -- 项目描述
    ,cont_circl_flg -- 合同可循环标志
    ,org_id -- 机构编号
    ,cap_supv_acct_id -- 资金监管账户编号
    ,cap_supv_acct_name -- 资金监管账户名称
    ,proj_stl_acct_id -- 项目结算账户编号
    ,proj_stl_acct_name -- 项目结算账户名称
    ,proj_stl_open_acct_bank_org_id -- 项目结算开户银行机构编号
    ,proj_stl_open_acct_org_id -- 项目结算开户机构编号
    ,appl_type_cd -- 申请类型代码
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,move_remark -- 迁移备注
    ,cmplt_flg -- 完成标志
    ,final_update_dt -- 最后更新日期
    ,proj_intror_name -- 项目介绍人名称
    ,fit_org_range_cd -- 适用机构范围代码
    ,expt_lmt_flg -- 例外额度标志
    ,paid_in_capital -- 实收资本
    ,co_mode_cd -- 合作模式代码
    ,init_agt_id -- 原协议编号
    ,bus_max_open_amt -- 业务最大敞口金额
    ,rgst_cap -- 注册资本
    ,early_days_start_use_lmt -- 前期启用额度
    ,lmt_nmal_amt -- 额度名义金额
    ,circl_flg -- 循环标志
    ,invo_syn_crdt_apv_reply_modif_flg -- 涉及综合信贷审批批复变更标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
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
    ,o.co_proj_id -- 合作项目编号
    ,o.co_proj_name -- 合作项目名称
    ,o.co_proj_type_cd -- 合作项目类型代码
    ,o.partner_id -- 合作方编号
    ,o.partner_type_cd -- 合作方类型代码
    ,o.coprator_type_cd -- 合作商类型代码
    ,o.partner_capital_ratio -- 合作方资本金比例
    ,o.co_agt_id -- 合作协议编号
    ,o.have_proj_lmt_flg -- 有项目额度标志
    ,o.proj_begin_dt -- 项目起始日期
    ,o.proj_exp_dt -- 项目到期日期
    ,o.co_tenor -- 合作期限
    ,o.fee_rat -- 费率
    ,o.comm_ratio -- 佣金比例
    ,o.proj_status_cd -- 项目状态代码
    ,o.proj_descb -- 项目描述
    ,o.cont_circl_flg -- 合同可循环标志
    ,o.org_id -- 机构编号
    ,o.cap_supv_acct_id -- 资金监管账户编号
    ,o.cap_supv_acct_name -- 资金监管账户名称
    ,o.proj_stl_acct_id -- 项目结算账户编号
    ,o.proj_stl_acct_name -- 项目结算账户名称
    ,o.proj_stl_open_acct_bank_org_id -- 项目结算开户银行机构编号
    ,o.proj_stl_open_acct_org_id -- 项目结算开户机构编号
    ,o.appl_type_cd -- 申请类型代码
    ,o.hxb_rela_ps_flg -- 我行关联人标志
    ,o.move_remark -- 迁移备注
    ,o.cmplt_flg -- 完成标志
    ,o.final_update_dt -- 最后更新日期
    ,o.proj_intror_name -- 项目介绍人名称
    ,o.fit_org_range_cd -- 适用机构范围代码
    ,o.expt_lmt_flg -- 例外额度标志
    ,o.paid_in_capital -- 实收资本
    ,o.co_mode_cd -- 合作模式代码
    ,o.init_agt_id -- 原协议编号
    ,o.bus_max_open_amt -- 业务最大敞口金额
    ,o.rgst_cap -- 注册资本
    ,o.early_days_start_use_lmt -- 前期启用额度
    ,o.lmt_nmal_amt -- 额度名义金额
    ,o.circl_flg -- 循环标志
    ,o.invo_syn_crdt_apv_reply_modif_flg -- 涉及综合信贷审批批复变更标志
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
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
from ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.co_proj_id = n.co_proj_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.co_proj_id = d.co_proj_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_crdt_partner_proj_basic_info_h;
--alter table ${iml_schema}.agt_crdt_partner_proj_basic_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_crdt_partner_proj_basic_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_crdt_partner_proj_basic_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_crdt_partner_proj_basic_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_crdt_partner_proj_basic_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_crdt_partner_proj_basic_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_crdt_partner_proj_basic_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_crdt_partner_proj_basic_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_crdt_partner_proj_basic_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
