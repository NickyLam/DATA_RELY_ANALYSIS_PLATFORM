/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_loan_prod_info_h_icmsf1
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
alter table ${iml_schema}.prd_loan_prod_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_loan_prod_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_loan_prod_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_loan_prod_info_h_icmsf1_tm purge;
drop table ${iml_schema}.prd_loan_prod_info_h_icmsf1_op purge;
drop table ${iml_schema}.prd_loan_prod_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_loan_prod_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_name -- 产品名称
    ,bus_breed_cd -- 业务品种代码
    ,super_prod_id -- 上级产品编号
    ,leaf_node_flg -- 叶节点标志
    ,mgmt_dept_id -- 管理部门编号
    ,bus_dept_id -- 产品发行机构编号
    ,exlus_prod_flg -- 专属产品标志
    ,off_bs_flg -- 表外标志
    ,allow_pkg_flg -- 允许打包标志
    ,lmt_prod_flg -- 额度产品标志
    ,loan_mon_tenor -- 期限值
    ,lmt_ocup_way_cd -- 额度被占用方式代码
    ,lmt_rela_agt_flg -- 额度关联协议标志
    ,ocup_lmt_flg -- 占用额度标志
    ,lmt_ocup_comnt -- 额度占用说明
    ,public_lmt_flg -- 公开额度标志
    ,lmt_uniq_flg -- 额度唯一标志
    ,uniq_fit_range_cd -- 唯一性适用范围代码
    ,fit_role_descb -- 适用角色描述
    ,lmt_fit_prod_descb -- 额度适用产品描述
    ,circl_idf_flg -- 循环标识标志
    ,aval_curr_cd -- 可用币种代码
    ,prod_status_cd -- 产品状态代码
    ,prod_descb -- 产品描述
    ,prod_effect_dt -- 产品生效日期
    ,prod_invalid_dt -- 产品失效日期
    ,prod_belong_gen_cd -- 产品所属大类代码
    ,base_claus_model_id -- 基础条款模型编号
    ,rela_claus_model_id -- 关联条款模型编号
    ,noth_risk_bus_flg -- 无风险业务标志
    ,all_open_bus_flg -- 全敞口业务标志
    ,allow_multi_out_acct_flg -- 允许多次出账标志
    ,allow_adv_repay_flg -- 允许提前还款标志
    ,prod_type_cd -- 产品类型代码
    ,allow_multi_distr_flg -- 允许多次放款标志
    ,proc_cap_usage_check_flg -- 进行资金用途检查标志
    ,lmt_ctrl_stage_cd -- 额度管控阶段代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,crdt_prod_cate_cd -- 信贷产品类别代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,group_ctrl_flg -- 集团控制标志
    ,prtcpt_single_cust_crdt_lmt_calc_flg -- 参与单一客户信用限额计算标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_loan_prod_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.prd_loan_prod_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_loan_prod_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.prd_loan_prod_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_loan_prod_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_prd_catalog-1
insert into ${iml_schema}.prd_loan_prod_info_h_icmsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_name -- 产品名称
    ,bus_breed_cd -- 业务品种代码
    ,super_prod_id -- 上级产品编号
    ,leaf_node_flg -- 叶节点标志
    ,mgmt_dept_id -- 管理部门编号
    ,bus_dept_id -- 产品发行机构编号
    ,exlus_prod_flg -- 专属产品标志
    ,off_bs_flg -- 表外标志
    ,allow_pkg_flg -- 允许打包标志
    ,lmt_prod_flg -- 额度产品标志
    ,loan_mon_tenor -- 期限值
    ,lmt_ocup_way_cd -- 额度被占用方式代码
    ,lmt_rela_agt_flg -- 额度关联协议标志
    ,ocup_lmt_flg -- 占用额度标志
    ,lmt_ocup_comnt -- 额度占用说明
    ,public_lmt_flg -- 公开额度标志
    ,lmt_uniq_flg -- 额度唯一标志
    ,uniq_fit_range_cd -- 唯一性适用范围代码
    ,fit_role_descb -- 适用角色描述
    ,lmt_fit_prod_descb -- 额度适用产品描述
    ,circl_idf_flg -- 循环标识标志
    ,aval_curr_cd -- 可用币种代码
    ,prod_status_cd -- 产品状态代码
    ,prod_descb -- 产品描述
    ,prod_effect_dt -- 产品生效日期
    ,prod_invalid_dt -- 产品失效日期
    ,prod_belong_gen_cd -- 产品所属大类代码
    ,base_claus_model_id -- 基础条款模型编号
    ,rela_claus_model_id -- 关联条款模型编号
    ,noth_risk_bus_flg -- 无风险业务标志
    ,all_open_bus_flg -- 全敞口业务标志
    ,allow_multi_out_acct_flg -- 允许多次出账标志
    ,allow_adv_repay_flg -- 允许提前还款标志
    ,prod_type_cd -- 产品类型代码
    ,allow_multi_distr_flg -- 允许多次放款标志
    ,proc_cap_usage_check_flg -- 进行资金用途检查标志
    ,lmt_ctrl_stage_cd -- 额度管控阶段代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,crdt_prod_cate_cd -- 信贷产品类别代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,group_ctrl_flg -- 集团控制标志
    ,prtcpt_single_cust_crdt_lmt_calc_flg -- 参与单一客户信用限额计算标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.PRODUCTID -- 产品编号
    ,'9999' -- 法人编号
    ,P1.PRODUCTNAME -- 产品名称
    ,nvl(trim(P1.ENTCREDITCLASSIFY),'-') -- 业务品种代码
    ,P1.PARENTPRODUCTID -- 上级产品编号
    ,P1.ISLEAFNODE -- 叶节点标志
    ,P1.BELONGDEPT -- 管理部门编号
    ,P1.USABLEDEPT -- 产品发行机构编号
    ,P1.EXFLUSIVEFLAG -- 专属产品标志
    ,nvl(trim(P1.OFFSHEETFLAG),'-') -- 表外标志
    ,P1.PERMITPACKAGE -- 允许打包标志
    ,P1.BUSINESSFLAG -- 额度产品标志
    ,P1.BASEPRODUCT -- 期限值
    ,P1.OCCUPYTYPE -- 额度被占用方式代码
    ,P1.LIMITRELAPROTOCAL -- 额度关联协议标志
    ,P1.OCCUPYLIMIT -- 占用额度标志
    ,P1.OCCUPYLIMITDESC -- 额度占用说明
    ,P1.PUBLICLIMIT -- 公开额度标志
    ,P1.UNIQUELIMIT -- 额度唯一标志
    ,NVL(P1.UNIQUESUITSCOPE,'-') -- 唯一性适用范围代码
    ,P1.SUITROLES -- 适用角色描述
    ,P1.UNDERPRODUCT -- 额度适用产品描述
    ,P1.ROTATIVE -- 循环标识标志
    ,nvl(trim(P1.SUITCURRENCY),'-') -- 可用币种代码
    ,P1.PRODUCTSTATUS -- 产品状态代码
    ,P1.PRODUCTDESC -- 产品描述
    ,P1.EFFECTIVEDATE -- 产品生效日期
    ,P1.EXPIRYDATE -- 产品失效日期
    ,nvl(trim(P1.PRODUCTCLASSIFY),'-') -- 产品所属大类代码
    ,P1.BASETERMMODELNO -- 基础条款模型编号
    ,P1.RELATERMMODELNO -- 关联条款模型编号
    ,P1.NORISK -- 无风险业务标志
    ,P1.TOTALEXPOSURE -- 全敞口业务标志
    ,P1.MULTIPUTOUT -- 允许多次出账标志
    ,P1.EARLYREPAYMENT -- 允许提前还款标志
    ,nvl(trim(P1.PRODUCTTYPE),'-') -- 产品类型代码
    ,P1.MULTILOAN -- 允许多次放款标志
    ,P1.ISCAPITALPURPOSECHECK -- 进行资金用途检查标志
    ,nvl(trim(P1.LIMITPERIOD),'-') -- 额度管控阶段代码
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 变更日期
    ,case
       when substr(P1.PRODUCTID, 1, 3) in ('203', '204') then '1' -- 对公贷款
       when substr(P1.PRODUCTID, 1, 3) in ('201', '202') and
            substr(P1.PRODUCTID, 1, 7) not in ('2020201', '2020101') then '2' -- 零售贷款
       when substr(P1.PRODUCTID, 1, 7) in ('2020201', '2020101') then '3' -- 联合网贷
       when P1.PRODUCTID = '602030100002' then '4' -- 个人委托贷款
       when P1.PRODUCTID = '602030100001' then '5' -- 单位委托贷款
       else '-'
     end -- 信贷产品类别代码
    ,nvl(trim(P1.ASSETTHREETYPE),'-') -- 资产三分类代码
    ,decode(P1.ISGROUPLIMIT,' ','-','Y','1','N','0',P1.ISGROUPLIMIT) -- 集团控制标志
    ,decode(P1.ISCALLIMIT,' ','-','Y','1','N','0',P1.ISCALLIMIT) -- 参与单一客户信用限额计算标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_prd_catalog' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_prd_catalog p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_loan_prod_info_h_icmsf1_tm 
  	                                group by 
  	                                        prod_id
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
        into ${iml_schema}.prd_loan_prod_info_h_icmsf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_name -- 产品名称
    ,bus_breed_cd -- 业务品种代码
    ,super_prod_id -- 上级产品编号
    ,leaf_node_flg -- 叶节点标志
    ,mgmt_dept_id -- 管理部门编号
    ,bus_dept_id -- 产品发行机构编号
    ,exlus_prod_flg -- 专属产品标志
    ,off_bs_flg -- 表外标志
    ,allow_pkg_flg -- 允许打包标志
    ,lmt_prod_flg -- 额度产品标志
    ,loan_mon_tenor -- 期限值
    ,lmt_ocup_way_cd -- 额度被占用方式代码
    ,lmt_rela_agt_flg -- 额度关联协议标志
    ,ocup_lmt_flg -- 占用额度标志
    ,lmt_ocup_comnt -- 额度占用说明
    ,public_lmt_flg -- 公开额度标志
    ,lmt_uniq_flg -- 额度唯一标志
    ,uniq_fit_range_cd -- 唯一性适用范围代码
    ,fit_role_descb -- 适用角色描述
    ,lmt_fit_prod_descb -- 额度适用产品描述
    ,circl_idf_flg -- 循环标识标志
    ,aval_curr_cd -- 可用币种代码
    ,prod_status_cd -- 产品状态代码
    ,prod_descb -- 产品描述
    ,prod_effect_dt -- 产品生效日期
    ,prod_invalid_dt -- 产品失效日期
    ,prod_belong_gen_cd -- 产品所属大类代码
    ,base_claus_model_id -- 基础条款模型编号
    ,rela_claus_model_id -- 关联条款模型编号
    ,noth_risk_bus_flg -- 无风险业务标志
    ,all_open_bus_flg -- 全敞口业务标志
    ,allow_multi_out_acct_flg -- 允许多次出账标志
    ,allow_adv_repay_flg -- 允许提前还款标志
    ,prod_type_cd -- 产品类型代码
    ,allow_multi_distr_flg -- 允许多次放款标志
    ,proc_cap_usage_check_flg -- 进行资金用途检查标志
    ,lmt_ctrl_stage_cd -- 额度管控阶段代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,crdt_prod_cate_cd -- 信贷产品类别代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,group_ctrl_flg -- 集团控制标志
    ,prtcpt_single_cust_crdt_lmt_calc_flg -- 参与单一客户信用限额计算标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_loan_prod_info_h_icmsf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_name -- 产品名称
    ,bus_breed_cd -- 业务品种代码
    ,super_prod_id -- 上级产品编号
    ,leaf_node_flg -- 叶节点标志
    ,mgmt_dept_id -- 管理部门编号
    ,bus_dept_id -- 产品发行机构编号
    ,exlus_prod_flg -- 专属产品标志
    ,off_bs_flg -- 表外标志
    ,allow_pkg_flg -- 允许打包标志
    ,lmt_prod_flg -- 额度产品标志
    ,loan_mon_tenor -- 期限值
    ,lmt_ocup_way_cd -- 额度被占用方式代码
    ,lmt_rela_agt_flg -- 额度关联协议标志
    ,ocup_lmt_flg -- 占用额度标志
    ,lmt_ocup_comnt -- 额度占用说明
    ,public_lmt_flg -- 公开额度标志
    ,lmt_uniq_flg -- 额度唯一标志
    ,uniq_fit_range_cd -- 唯一性适用范围代码
    ,fit_role_descb -- 适用角色描述
    ,lmt_fit_prod_descb -- 额度适用产品描述
    ,circl_idf_flg -- 循环标识标志
    ,aval_curr_cd -- 可用币种代码
    ,prod_status_cd -- 产品状态代码
    ,prod_descb -- 产品描述
    ,prod_effect_dt -- 产品生效日期
    ,prod_invalid_dt -- 产品失效日期
    ,prod_belong_gen_cd -- 产品所属大类代码
    ,base_claus_model_id -- 基础条款模型编号
    ,rela_claus_model_id -- 关联条款模型编号
    ,noth_risk_bus_flg -- 无风险业务标志
    ,all_open_bus_flg -- 全敞口业务标志
    ,allow_multi_out_acct_flg -- 允许多次出账标志
    ,allow_adv_repay_flg -- 允许提前还款标志
    ,prod_type_cd -- 产品类型代码
    ,allow_multi_distr_flg -- 允许多次放款标志
    ,proc_cap_usage_check_flg -- 进行资金用途检查标志
    ,lmt_ctrl_stage_cd -- 额度管控阶段代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,crdt_prod_cate_cd -- 信贷产品类别代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,group_ctrl_flg -- 集团控制标志
    ,prtcpt_single_cust_crdt_lmt_calc_flg -- 参与单一客户信用限额计算标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.bus_breed_cd, o.bus_breed_cd) as bus_breed_cd -- 业务品种代码
    ,nvl(n.super_prod_id, o.super_prod_id) as super_prod_id -- 上级产品编号
    ,nvl(n.leaf_node_flg, o.leaf_node_flg) as leaf_node_flg -- 叶节点标志
    ,nvl(n.mgmt_dept_id, o.mgmt_dept_id) as mgmt_dept_id -- 管理部门编号
    ,nvl(n.bus_dept_id, o.bus_dept_id) as bus_dept_id -- 产品发行机构编号
    ,nvl(n.exlus_prod_flg, o.exlus_prod_flg) as exlus_prod_flg -- 专属产品标志
    ,nvl(n.off_bs_flg, o.off_bs_flg) as off_bs_flg -- 表外标志
    ,nvl(n.allow_pkg_flg, o.allow_pkg_flg) as allow_pkg_flg -- 允许打包标志
    ,nvl(n.lmt_prod_flg, o.lmt_prod_flg) as lmt_prod_flg -- 额度产品标志
    ,nvl(n.loan_mon_tenor, o.loan_mon_tenor) as loan_mon_tenor -- 期限值
    ,nvl(n.lmt_ocup_way_cd, o.lmt_ocup_way_cd) as lmt_ocup_way_cd -- 额度被占用方式代码
    ,nvl(n.lmt_rela_agt_flg, o.lmt_rela_agt_flg) as lmt_rela_agt_flg -- 额度关联协议标志
    ,nvl(n.ocup_lmt_flg, o.ocup_lmt_flg) as ocup_lmt_flg -- 占用额度标志
    ,nvl(n.lmt_ocup_comnt, o.lmt_ocup_comnt) as lmt_ocup_comnt -- 额度占用说明
    ,nvl(n.public_lmt_flg, o.public_lmt_flg) as public_lmt_flg -- 公开额度标志
    ,nvl(n.lmt_uniq_flg, o.lmt_uniq_flg) as lmt_uniq_flg -- 额度唯一标志
    ,nvl(n.uniq_fit_range_cd, o.uniq_fit_range_cd) as uniq_fit_range_cd -- 唯一性适用范围代码
    ,nvl(n.fit_role_descb, o.fit_role_descb) as fit_role_descb -- 适用角色描述
    ,nvl(n.lmt_fit_prod_descb, o.lmt_fit_prod_descb) as lmt_fit_prod_descb -- 额度适用产品描述
    ,nvl(n.circl_idf_flg, o.circl_idf_flg) as circl_idf_flg -- 循环标识标志
    ,nvl(n.aval_curr_cd, o.aval_curr_cd) as aval_curr_cd -- 可用币种代码
    ,nvl(n.prod_status_cd, o.prod_status_cd) as prod_status_cd -- 产品状态代码
    ,nvl(n.prod_descb, o.prod_descb) as prod_descb -- 产品描述
    ,nvl(n.prod_effect_dt, o.prod_effect_dt) as prod_effect_dt -- 产品生效日期
    ,nvl(n.prod_invalid_dt, o.prod_invalid_dt) as prod_invalid_dt -- 产品失效日期
    ,nvl(n.prod_belong_gen_cd, o.prod_belong_gen_cd) as prod_belong_gen_cd -- 产品所属大类代码
    ,nvl(n.base_claus_model_id, o.base_claus_model_id) as base_claus_model_id -- 基础条款模型编号
    ,nvl(n.rela_claus_model_id, o.rela_claus_model_id) as rela_claus_model_id -- 关联条款模型编号
    ,nvl(n.noth_risk_bus_flg, o.noth_risk_bus_flg) as noth_risk_bus_flg -- 无风险业务标志
    ,nvl(n.all_open_bus_flg, o.all_open_bus_flg) as all_open_bus_flg -- 全敞口业务标志
    ,nvl(n.allow_multi_out_acct_flg, o.allow_multi_out_acct_flg) as allow_multi_out_acct_flg -- 允许多次出账标志
    ,nvl(n.allow_adv_repay_flg, o.allow_adv_repay_flg) as allow_adv_repay_flg -- 允许提前还款标志
    ,nvl(n.prod_type_cd, o.prod_type_cd) as prod_type_cd -- 产品类型代码
    ,nvl(n.allow_multi_distr_flg, o.allow_multi_distr_flg) as allow_multi_distr_flg -- 允许多次放款标志
    ,nvl(n.proc_cap_usage_check_flg, o.proc_cap_usage_check_flg) as proc_cap_usage_check_flg -- 进行资金用途检查标志
    ,nvl(n.lmt_ctrl_stage_cd, o.lmt_ctrl_stage_cd) as lmt_ctrl_stage_cd -- 额度管控阶段代码
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 变更日期
    ,nvl(n.crdt_prod_cate_cd, o.crdt_prod_cate_cd) as crdt_prod_cate_cd -- 信贷产品类别代码
    ,nvl(n.asset_thd_cls_cd, o.asset_thd_cls_cd) as asset_thd_cls_cd -- 资产三分类代码
    ,nvl(n.group_ctrl_flg, o.group_ctrl_flg) as group_ctrl_flg -- 集团控制标志
    ,nvl(n.prtcpt_single_cust_crdt_lmt_calc_flg, o.prtcpt_single_cust_crdt_lmt_calc_flg) as prtcpt_single_cust_crdt_lmt_calc_flg -- 参与单一客户信用限额计算标志
    ,case when
            n.prod_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_loan_prod_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.prd_loan_prod_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
where (
        o.prod_id is null
        and o.lp_id is null
    )
    or (
        n.prod_id is null
        and n.lp_id is null
    )
    or (
        o.prod_name <> n.prod_name
        or o.bus_breed_cd <> n.bus_breed_cd
        or o.super_prod_id <> n.super_prod_id
        or o.leaf_node_flg <> n.leaf_node_flg
        or o.mgmt_dept_id <> n.mgmt_dept_id
        or o.bus_dept_id <> n.bus_dept_id
        or o.exlus_prod_flg <> n.exlus_prod_flg
        or o.off_bs_flg <> n.off_bs_flg
        or o.allow_pkg_flg <> n.allow_pkg_flg
        or o.lmt_prod_flg <> n.lmt_prod_flg
        or o.loan_mon_tenor <> n.loan_mon_tenor
        or o.lmt_ocup_way_cd <> n.lmt_ocup_way_cd
        or o.lmt_rela_agt_flg <> n.lmt_rela_agt_flg
        or o.ocup_lmt_flg <> n.ocup_lmt_flg
        or o.lmt_ocup_comnt <> n.lmt_ocup_comnt
        or o.public_lmt_flg <> n.public_lmt_flg
        or o.lmt_uniq_flg <> n.lmt_uniq_flg
        or o.uniq_fit_range_cd <> n.uniq_fit_range_cd
        or o.fit_role_descb <> n.fit_role_descb
        or o.lmt_fit_prod_descb <> n.lmt_fit_prod_descb
        or o.circl_idf_flg <> n.circl_idf_flg
        or o.aval_curr_cd <> n.aval_curr_cd
        or o.prod_status_cd <> n.prod_status_cd
        or o.prod_descb <> n.prod_descb
        or o.prod_effect_dt <> n.prod_effect_dt
        or o.prod_invalid_dt <> n.prod_invalid_dt
        or o.prod_belong_gen_cd <> n.prod_belong_gen_cd
        or o.base_claus_model_id <> n.base_claus_model_id
        or o.rela_claus_model_id <> n.rela_claus_model_id
        or o.noth_risk_bus_flg <> n.noth_risk_bus_flg
        or o.all_open_bus_flg <> n.all_open_bus_flg
        or o.allow_multi_out_acct_flg <> n.allow_multi_out_acct_flg
        or o.allow_adv_repay_flg <> n.allow_adv_repay_flg
        or o.prod_type_cd <> n.prod_type_cd
        or o.allow_multi_distr_flg <> n.allow_multi_distr_flg
        or o.proc_cap_usage_check_flg <> n.proc_cap_usage_check_flg
        or o.lmt_ctrl_stage_cd <> n.lmt_ctrl_stage_cd
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.modif_dt <> n.modif_dt
        or o.crdt_prod_cate_cd <> n.crdt_prod_cate_cd
        or o.asset_thd_cls_cd <> n.asset_thd_cls_cd
        or o.group_ctrl_flg <> n.group_ctrl_flg
        or o.prtcpt_single_cust_crdt_lmt_calc_flg <> n.prtcpt_single_cust_crdt_lmt_calc_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_loan_prod_info_h_icmsf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_name -- 产品名称
    ,bus_breed_cd -- 业务品种代码
    ,super_prod_id -- 上级产品编号
    ,leaf_node_flg -- 叶节点标志
    ,mgmt_dept_id -- 管理部门编号
    ,bus_dept_id -- 产品发行机构编号
    ,exlus_prod_flg -- 专属产品标志
    ,off_bs_flg -- 表外标志
    ,allow_pkg_flg -- 允许打包标志
    ,lmt_prod_flg -- 额度产品标志
    ,loan_mon_tenor -- 期限值
    ,lmt_ocup_way_cd -- 额度被占用方式代码
    ,lmt_rela_agt_flg -- 额度关联协议标志
    ,ocup_lmt_flg -- 占用额度标志
    ,lmt_ocup_comnt -- 额度占用说明
    ,public_lmt_flg -- 公开额度标志
    ,lmt_uniq_flg -- 额度唯一标志
    ,uniq_fit_range_cd -- 唯一性适用范围代码
    ,fit_role_descb -- 适用角色描述
    ,lmt_fit_prod_descb -- 额度适用产品描述
    ,circl_idf_flg -- 循环标识标志
    ,aval_curr_cd -- 可用币种代码
    ,prod_status_cd -- 产品状态代码
    ,prod_descb -- 产品描述
    ,prod_effect_dt -- 产品生效日期
    ,prod_invalid_dt -- 产品失效日期
    ,prod_belong_gen_cd -- 产品所属大类代码
    ,base_claus_model_id -- 基础条款模型编号
    ,rela_claus_model_id -- 关联条款模型编号
    ,noth_risk_bus_flg -- 无风险业务标志
    ,all_open_bus_flg -- 全敞口业务标志
    ,allow_multi_out_acct_flg -- 允许多次出账标志
    ,allow_adv_repay_flg -- 允许提前还款标志
    ,prod_type_cd -- 产品类型代码
    ,allow_multi_distr_flg -- 允许多次放款标志
    ,proc_cap_usage_check_flg -- 进行资金用途检查标志
    ,lmt_ctrl_stage_cd -- 额度管控阶段代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,crdt_prod_cate_cd -- 信贷产品类别代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,group_ctrl_flg -- 集团控制标志
    ,prtcpt_single_cust_crdt_lmt_calc_flg -- 参与单一客户信用限额计算标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_loan_prod_info_h_icmsf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_name -- 产品名称
    ,bus_breed_cd -- 业务品种代码
    ,super_prod_id -- 上级产品编号
    ,leaf_node_flg -- 叶节点标志
    ,mgmt_dept_id -- 管理部门编号
    ,bus_dept_id -- 产品发行机构编号
    ,exlus_prod_flg -- 专属产品标志
    ,off_bs_flg -- 表外标志
    ,allow_pkg_flg -- 允许打包标志
    ,lmt_prod_flg -- 额度产品标志
    ,loan_mon_tenor -- 期限值
    ,lmt_ocup_way_cd -- 额度被占用方式代码
    ,lmt_rela_agt_flg -- 额度关联协议标志
    ,ocup_lmt_flg -- 占用额度标志
    ,lmt_ocup_comnt -- 额度占用说明
    ,public_lmt_flg -- 公开额度标志
    ,lmt_uniq_flg -- 额度唯一标志
    ,uniq_fit_range_cd -- 唯一性适用范围代码
    ,fit_role_descb -- 适用角色描述
    ,lmt_fit_prod_descb -- 额度适用产品描述
    ,circl_idf_flg -- 循环标识标志
    ,aval_curr_cd -- 可用币种代码
    ,prod_status_cd -- 产品状态代码
    ,prod_descb -- 产品描述
    ,prod_effect_dt -- 产品生效日期
    ,prod_invalid_dt -- 产品失效日期
    ,prod_belong_gen_cd -- 产品所属大类代码
    ,base_claus_model_id -- 基础条款模型编号
    ,rela_claus_model_id -- 关联条款模型编号
    ,noth_risk_bus_flg -- 无风险业务标志
    ,all_open_bus_flg -- 全敞口业务标志
    ,allow_multi_out_acct_flg -- 允许多次出账标志
    ,allow_adv_repay_flg -- 允许提前还款标志
    ,prod_type_cd -- 产品类型代码
    ,allow_multi_distr_flg -- 允许多次放款标志
    ,proc_cap_usage_check_flg -- 进行资金用途检查标志
    ,lmt_ctrl_stage_cd -- 额度管控阶段代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,crdt_prod_cate_cd -- 信贷产品类别代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,group_ctrl_flg -- 集团控制标志
    ,prtcpt_single_cust_crdt_lmt_calc_flg -- 参与单一客户信用限额计算标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prod_id -- 产品编号
    ,o.lp_id -- 法人编号
    ,o.prod_name -- 产品名称
    ,o.bus_breed_cd -- 业务品种代码
    ,o.super_prod_id -- 上级产品编号
    ,o.leaf_node_flg -- 叶节点标志
    ,o.mgmt_dept_id -- 管理部门编号
    ,o.bus_dept_id -- 产品发行机构编号
    ,o.exlus_prod_flg -- 专属产品标志
    ,o.off_bs_flg -- 表外标志
    ,o.allow_pkg_flg -- 允许打包标志
    ,o.lmt_prod_flg -- 额度产品标志
    ,o.loan_mon_tenor -- 期限值
    ,o.lmt_ocup_way_cd -- 额度被占用方式代码
    ,o.lmt_rela_agt_flg -- 额度关联协议标志
    ,o.ocup_lmt_flg -- 占用额度标志
    ,o.lmt_ocup_comnt -- 额度占用说明
    ,o.public_lmt_flg -- 公开额度标志
    ,o.lmt_uniq_flg -- 额度唯一标志
    ,o.uniq_fit_range_cd -- 唯一性适用范围代码
    ,o.fit_role_descb -- 适用角色描述
    ,o.lmt_fit_prod_descb -- 额度适用产品描述
    ,o.circl_idf_flg -- 循环标识标志
    ,o.aval_curr_cd -- 可用币种代码
    ,o.prod_status_cd -- 产品状态代码
    ,o.prod_descb -- 产品描述
    ,o.prod_effect_dt -- 产品生效日期
    ,o.prod_invalid_dt -- 产品失效日期
    ,o.prod_belong_gen_cd -- 产品所属大类代码
    ,o.base_claus_model_id -- 基础条款模型编号
    ,o.rela_claus_model_id -- 关联条款模型编号
    ,o.noth_risk_bus_flg -- 无风险业务标志
    ,o.all_open_bus_flg -- 全敞口业务标志
    ,o.allow_multi_out_acct_flg -- 允许多次出账标志
    ,o.allow_adv_repay_flg -- 允许提前还款标志
    ,o.prod_type_cd -- 产品类型代码
    ,o.allow_multi_distr_flg -- 允许多次放款标志
    ,o.proc_cap_usage_check_flg -- 进行资金用途检查标志
    ,o.lmt_ctrl_stage_cd -- 额度管控阶段代码
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.modif_dt -- 变更日期
    ,o.crdt_prod_cate_cd -- 信贷产品类别代码
    ,o.asset_thd_cls_cd -- 资产三分类代码
    ,o.group_ctrl_flg -- 集团控制标志
    ,o.prtcpt_single_cust_crdt_lmt_calc_flg -- 参与单一客户信用限额计算标志
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
from ${iml_schema}.prd_loan_prod_info_h_icmsf1_bk o
    left join ${iml_schema}.prd_loan_prod_info_h_icmsf1_op n
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_loan_prod_info_h_icmsf1_cl d
        on
            o.prod_id = d.prod_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_loan_prod_info_h;
--alter table ${iml_schema}.prd_loan_prod_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('prd_loan_prod_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.prd_loan_prod_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_loan_prod_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.prd_loan_prod_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.prd_loan_prod_info_h_icmsf1_cl;
alter table ${iml_schema}.prd_loan_prod_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.prd_loan_prod_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_loan_prod_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_loan_prod_info_h_icmsf1_tm purge;
drop table ${iml_schema}.prd_loan_prod_info_h_icmsf1_op purge;
drop table ${iml_schema}.prd_loan_prod_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_loan_prod_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_loan_prod_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
