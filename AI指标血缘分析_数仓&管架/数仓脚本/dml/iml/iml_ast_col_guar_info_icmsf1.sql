/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_guar_info_icmsf1
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
alter table ${iml_schema}.ast_col_guar_info add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_guar_info_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_guar_info partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ast_col_guar_info_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_guar_info_icmsf1_op purge;
drop table ${iml_schema}.ast_col_guar_info_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_guar_info_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    col_id -- 押品编号
    ,lp_id -- 法人编号
    ,col_name -- 押品名称
    ,col_type_cd -- 押品类型代码
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_way_cd -- 担保方式代码
    ,guar_status_cd -- 担保状态代码
    ,guar_amt -- 担保金额
    ,guar_curr_cd -- 担保币种代码
    ,guar_corp_margin_amt -- 担保公司保证金金额
    ,stage_guar_flg -- 阶段性担保标志
    ,estim_org_name -- 评估机构名称
    ,estim_val -- 评估价值
    ,evltion_dt -- 估值日期
    ,rel_esat_cert_id -- 不动产证号
    ,rel_esat_arch_area -- 不动产建筑面积
    ,mtg_addr -- 抵押物地址
    ,log_id -- 保函编号
    ,log_type_cd -- 保函类型代码
    ,log_amt -- 保函金额
    ,log_curr_cd -- 保函币种代码
    ,log_issue_cty_cd -- 保函开证国家代码
    ,open_org_name -- 开立机构名称
    ,open_org_type_cd -- 开立机构类型代码
    ,irevbl_flg -- 不可撤销标志
    ,finc_turn_margin_col_id -- 理财转保证金押品编号
    ,guartor_type_cd -- 保证人类型代码
    ,guartor_id -- 保证人编号
    ,guartor_name -- 保证人名称
    ,guartor_cert_type_cd -- 保证人证件类型代码
    ,guartor_cert_no -- 保证人证件号码
    ,guartor_guar_indep_cd -- 保证人担保独立性代码
    ,guartor_rgst_cty_cd -- 保证人注册地国家代码
    ,guartor_rgst_ext_rating_cd -- 保证人注册地外部评级代码
    ,guartor_ext_rating_dt -- 保证人外部评级日期
    ,guartor_ext_rating_cd -- 保证人外部评级代码
    ,guartor_intnal_rating_dt -- 保证人内部评级日期
    ,guartor_intnal_rating_cd -- 保证人内部评级代码
    ,guartor_ownsp_type_cd -- 保证人所有制类型代码
    ,guartor_net_asset -- 保证人净资产
    ,net_asset_curr_cd -- 净资产币种代码
    ,guar_insure_policy_num -- 保证保险保单号码
    ,guar_aim_cd -- 保证目的代码
    ,resdnt_flg -- 居民标志
    ,remark -- 备注
    ,rgst_dt -- 登记日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,last_update_dt -- 最后更新日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_guar_info partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.ast_col_guar_info_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_guar_info partition for ('icmsf1') where 0=1;

create table ${iml_schema}.ast_col_guar_info_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_guar_info partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_guaranty_info-1
insert into ${iml_schema}.ast_col_guar_info_icmsf1_tm(
    col_id -- 押品编号
    ,lp_id -- 法人编号
    ,col_name -- 押品名称
    ,col_type_cd -- 押品类型代码
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_way_cd -- 担保方式代码
    ,guar_status_cd -- 担保状态代码
    ,guar_amt -- 担保金额
    ,guar_curr_cd -- 担保币种代码
    ,guar_corp_margin_amt -- 担保公司保证金金额
    ,stage_guar_flg -- 阶段性担保标志
    ,estim_org_name -- 评估机构名称
    ,estim_val -- 评估价值
    ,evltion_dt -- 估值日期
    ,rel_esat_cert_id -- 不动产证号
    ,rel_esat_arch_area -- 不动产建筑面积
    ,mtg_addr -- 抵押物地址
    ,log_id -- 保函编号
    ,log_type_cd -- 保函类型代码
    ,log_amt -- 保函金额
    ,log_curr_cd -- 保函币种代码
    ,log_issue_cty_cd -- 保函开证国家代码
    ,open_org_name -- 开立机构名称
    ,open_org_type_cd -- 开立机构类型代码
    ,irevbl_flg -- 不可撤销标志
    ,finc_turn_margin_col_id -- 理财转保证金押品编号
    ,guartor_type_cd -- 保证人类型代码
    ,guartor_id -- 保证人编号
    ,guartor_name -- 保证人名称
    ,guartor_cert_type_cd -- 保证人证件类型代码
    ,guartor_cert_no -- 保证人证件号码
    ,guartor_guar_indep_cd -- 保证人担保独立性代码
    ,guartor_rgst_cty_cd -- 保证人注册地国家代码
    ,guartor_rgst_ext_rating_cd -- 保证人注册地外部评级代码
    ,guartor_ext_rating_dt -- 保证人外部评级日期
    ,guartor_ext_rating_cd -- 保证人外部评级代码
    ,guartor_intnal_rating_dt -- 保证人内部评级日期
    ,guartor_intnal_rating_cd -- 保证人内部评级代码
    ,guartor_ownsp_type_cd -- 保证人所有制类型代码
    ,guartor_net_asset -- 保证人净资产
    ,net_asset_curr_cd -- 净资产币种代码
    ,guar_insure_policy_num -- 保证保险保单号码
    ,guar_aim_cd -- 保证目的代码
    ,resdnt_flg -- 居民标志
    ,remark -- 备注
    ,rgst_dt -- 登记日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,last_update_dt -- 最后更新日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.GUARANTYID -- 押品编号
    ,'9999' -- 法人编号
    ,P1.GUARANTYNAME -- 押品名称
    ,nvl(trim(P1.GUARANTYTYPE),'-') -- 押品类型代码
    ,nvl(trim(P1.GUARANTEETYPE),'-') -- 保证担保形式代码
    ,nvl(trim(P1.CONTRACTTYPE),'-') -- 担保方式代码
    ,nvl(trim(P1.GUARANTYSTATUS),'00') -- 担保状态代码
    ,P1.CONFIRMVALUE -- 担保金额
    ,nvl(trim(P1.CONFIRMCURRENCY),'-') -- 担保币种代码
    ,P1.GUARCASH -- 担保公司保证金金额
    ,nvl(trim(P1.ISSTAGE),'-') -- 阶段性担保标志
    ,P1.EVALORGNAME -- 评估机构名称
    ,P1.EVALUATENETVALUE -- 评估价值
    ,P1.EVALDATE -- 估值日期
    ,P1.REALESTATECODE -- 不动产证号
    ,P1.FLOORAREA -- 不动产建筑面积
    ,P1.GUARANTYLOCATION -- 抵押物地址
    ,P1.LETTERNO -- 保函编号
    ,nvl(trim(P1.LETTERTYPE),'-') -- 保函类型代码
    ,P1.LETTERSUM -- 保函金额
    ,nvl(trim(P1.LETTERCURRENCY),'-') -- 保函币种代码
    ,nvl(trim(P1.LETTERCONTRY),'XXX') -- 保函开证国家代码
    ,P1.ORGNAME -- 开立机构名称
    ,nvl(trim(P1.ORGTYPE),'00') -- 开立机构类型代码
    ,nvl(trim(P1.ISCANCEL),'-') -- 不可撤销标志
    ,P1.YPGUARANTYID -- 理财转保证金押品编号
    ,P1.OWNERTYPE -- 保证人类型代码
    ,P1.OWNERID -- 保证人编号
    ,P1.OWNERNAME -- 保证人名称
    ,nvl(trim(P1.CERTTYPE),'0000') -- 保证人证件类型代码
    ,P1.CERTID -- 保证人证件号码
    ,nvl(trim(P1.INDEPENDENCE),'-') -- 保证人担保独立性代码
    ,nvl(trim(P1.REGISTCOUNTRY),'XXX') -- 保证人注册地国家代码
    ,nvl(trim(P1.REGISTCOUNTRYRESULT),'-') -- 保证人注册地外部评级代码
    ,${iml_schema}.dateformat_max2(P1.OUTRATINGDATE) -- 保证人外部评级日期
    ,nvl(trim(P1.OUTRATINGRESULT),'-') -- 保证人外部评级代码
    ,${iml_schema}.dateformat_max2(P1.INRATINGDATE) -- 保证人内部评级日期
    ,nvl(trim(P1.INRATINGRESULT),'-') -- 保证人内部评级代码
    ,nvl(trim(P1.VOUCHERTYPE),'00') -- 保证人所有制类型代码
    ,P1.NETASSET -- 保证人净资产
    ,nvl(trim(P1.NETASSETCURRENCY),'-') -- 净资产币种代码
    ,P1.INSURANCENO -- 保证保险保单号码
    ,nvl(trim(P1.PURPOSE),'00') -- 保证目的代码
    ,nvl(trim(P1.ISRESIDENT),'-') -- 居民标志
    ,P1.REMARK -- 备注
    ,P1.INPUTDATE -- 登记日期
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_guaranty_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_guaranty_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_guar_info_icmsf1_tm 
  	                                group by 
  	                                        col_id
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
        into ${iml_schema}.ast_col_guar_info_icmsf1_cl(
            col_id -- 押品编号
    ,lp_id -- 法人编号
    ,col_name -- 押品名称
    ,col_type_cd -- 押品类型代码
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_way_cd -- 担保方式代码
    ,guar_status_cd -- 担保状态代码
    ,guar_amt -- 担保金额
    ,guar_curr_cd -- 担保币种代码
    ,guar_corp_margin_amt -- 担保公司保证金金额
    ,stage_guar_flg -- 阶段性担保标志
    ,estim_org_name -- 评估机构名称
    ,estim_val -- 评估价值
    ,evltion_dt -- 估值日期
    ,rel_esat_cert_id -- 不动产证号
    ,rel_esat_arch_area -- 不动产建筑面积
    ,mtg_addr -- 抵押物地址
    ,log_id -- 保函编号
    ,log_type_cd -- 保函类型代码
    ,log_amt -- 保函金额
    ,log_curr_cd -- 保函币种代码
    ,log_issue_cty_cd -- 保函开证国家代码
    ,open_org_name -- 开立机构名称
    ,open_org_type_cd -- 开立机构类型代码
    ,irevbl_flg -- 不可撤销标志
    ,finc_turn_margin_col_id -- 理财转保证金押品编号
    ,guartor_type_cd -- 保证人类型代码
    ,guartor_id -- 保证人编号
    ,guartor_name -- 保证人名称
    ,guartor_cert_type_cd -- 保证人证件类型代码
    ,guartor_cert_no -- 保证人证件号码
    ,guartor_guar_indep_cd -- 保证人担保独立性代码
    ,guartor_rgst_cty_cd -- 保证人注册地国家代码
    ,guartor_rgst_ext_rating_cd -- 保证人注册地外部评级代码
    ,guartor_ext_rating_dt -- 保证人外部评级日期
    ,guartor_ext_rating_cd -- 保证人外部评级代码
    ,guartor_intnal_rating_dt -- 保证人内部评级日期
    ,guartor_intnal_rating_cd -- 保证人内部评级代码
    ,guartor_ownsp_type_cd -- 保证人所有制类型代码
    ,guartor_net_asset -- 保证人净资产
    ,net_asset_curr_cd -- 净资产币种代码
    ,guar_insure_policy_num -- 保证保险保单号码
    ,guar_aim_cd -- 保证目的代码
    ,resdnt_flg -- 居民标志
    ,remark -- 备注
    ,rgst_dt -- 登记日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,last_update_dt -- 最后更新日期
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
        into ${iml_schema}.ast_col_guar_info_icmsf1_op(
            col_id -- 押品编号
    ,lp_id -- 法人编号
    ,col_name -- 押品名称
    ,col_type_cd -- 押品类型代码
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_way_cd -- 担保方式代码
    ,guar_status_cd -- 担保状态代码
    ,guar_amt -- 担保金额
    ,guar_curr_cd -- 担保币种代码
    ,guar_corp_margin_amt -- 担保公司保证金金额
    ,stage_guar_flg -- 阶段性担保标志
    ,estim_org_name -- 评估机构名称
    ,estim_val -- 评估价值
    ,evltion_dt -- 估值日期
    ,rel_esat_cert_id -- 不动产证号
    ,rel_esat_arch_area -- 不动产建筑面积
    ,mtg_addr -- 抵押物地址
    ,log_id -- 保函编号
    ,log_type_cd -- 保函类型代码
    ,log_amt -- 保函金额
    ,log_curr_cd -- 保函币种代码
    ,log_issue_cty_cd -- 保函开证国家代码
    ,open_org_name -- 开立机构名称
    ,open_org_type_cd -- 开立机构类型代码
    ,irevbl_flg -- 不可撤销标志
    ,finc_turn_margin_col_id -- 理财转保证金押品编号
    ,guartor_type_cd -- 保证人类型代码
    ,guartor_id -- 保证人编号
    ,guartor_name -- 保证人名称
    ,guartor_cert_type_cd -- 保证人证件类型代码
    ,guartor_cert_no -- 保证人证件号码
    ,guartor_guar_indep_cd -- 保证人担保独立性代码
    ,guartor_rgst_cty_cd -- 保证人注册地国家代码
    ,guartor_rgst_ext_rating_cd -- 保证人注册地外部评级代码
    ,guartor_ext_rating_dt -- 保证人外部评级日期
    ,guartor_ext_rating_cd -- 保证人外部评级代码
    ,guartor_intnal_rating_dt -- 保证人内部评级日期
    ,guartor_intnal_rating_cd -- 保证人内部评级代码
    ,guartor_ownsp_type_cd -- 保证人所有制类型代码
    ,guartor_net_asset -- 保证人净资产
    ,net_asset_curr_cd -- 净资产币种代码
    ,guar_insure_policy_num -- 保证保险保单号码
    ,guar_aim_cd -- 保证目的代码
    ,resdnt_flg -- 居民标志
    ,remark -- 备注
    ,rgst_dt -- 登记日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,last_update_dt -- 最后更新日期
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
    nvl(n.col_id, o.col_id) as col_id -- 押品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.col_name, o.col_name) as col_name -- 押品名称
    ,nvl(n.col_type_cd, o.col_type_cd) as col_type_cd -- 押品类型代码
    ,nvl(n.guar_guar_form_cd, o.guar_guar_form_cd) as guar_guar_form_cd -- 保证担保形式代码
    ,nvl(n.guar_way_cd, o.guar_way_cd) as guar_way_cd -- 担保方式代码
    ,nvl(n.guar_status_cd, o.guar_status_cd) as guar_status_cd -- 担保状态代码
    ,nvl(n.guar_amt, o.guar_amt) as guar_amt -- 担保金额
    ,nvl(n.guar_curr_cd, o.guar_curr_cd) as guar_curr_cd -- 担保币种代码
    ,nvl(n.guar_corp_margin_amt, o.guar_corp_margin_amt) as guar_corp_margin_amt -- 担保公司保证金金额
    ,nvl(n.stage_guar_flg, o.stage_guar_flg) as stage_guar_flg -- 阶段性担保标志
    ,nvl(n.estim_org_name, o.estim_org_name) as estim_org_name -- 评估机构名称
    ,nvl(n.estim_val, o.estim_val) as estim_val -- 评估价值
    ,nvl(n.evltion_dt, o.evltion_dt) as evltion_dt -- 估值日期
    ,nvl(n.rel_esat_cert_id, o.rel_esat_cert_id) as rel_esat_cert_id -- 不动产证号
    ,nvl(n.rel_esat_arch_area, o.rel_esat_arch_area) as rel_esat_arch_area -- 不动产建筑面积
    ,nvl(n.mtg_addr, o.mtg_addr) as mtg_addr -- 抵押物地址
    ,nvl(n.log_id, o.log_id) as log_id -- 保函编号
    ,nvl(n.log_type_cd, o.log_type_cd) as log_type_cd -- 保函类型代码
    ,nvl(n.log_amt, o.log_amt) as log_amt -- 保函金额
    ,nvl(n.log_curr_cd, o.log_curr_cd) as log_curr_cd -- 保函币种代码
    ,nvl(n.log_issue_cty_cd, o.log_issue_cty_cd) as log_issue_cty_cd -- 保函开证国家代码
    ,nvl(n.open_org_name, o.open_org_name) as open_org_name -- 开立机构名称
    ,nvl(n.open_org_type_cd, o.open_org_type_cd) as open_org_type_cd -- 开立机构类型代码
    ,nvl(n.irevbl_flg, o.irevbl_flg) as irevbl_flg -- 不可撤销标志
    ,nvl(n.finc_turn_margin_col_id, o.finc_turn_margin_col_id) as finc_turn_margin_col_id -- 理财转保证金押品编号
    ,nvl(n.guartor_type_cd, o.guartor_type_cd) as guartor_type_cd -- 保证人类型代码
    ,nvl(n.guartor_id, o.guartor_id) as guartor_id -- 保证人编号
    ,nvl(n.guartor_name, o.guartor_name) as guartor_name -- 保证人名称
    ,nvl(n.guartor_cert_type_cd, o.guartor_cert_type_cd) as guartor_cert_type_cd -- 保证人证件类型代码
    ,nvl(n.guartor_cert_no, o.guartor_cert_no) as guartor_cert_no -- 保证人证件号码
    ,nvl(n.guartor_guar_indep_cd, o.guartor_guar_indep_cd) as guartor_guar_indep_cd -- 保证人担保独立性代码
    ,nvl(n.guartor_rgst_cty_cd, o.guartor_rgst_cty_cd) as guartor_rgst_cty_cd -- 保证人注册地国家代码
    ,nvl(n.guartor_rgst_ext_rating_cd, o.guartor_rgst_ext_rating_cd) as guartor_rgst_ext_rating_cd -- 保证人注册地外部评级代码
    ,nvl(n.guartor_ext_rating_dt, o.guartor_ext_rating_dt) as guartor_ext_rating_dt -- 保证人外部评级日期
    ,nvl(n.guartor_ext_rating_cd, o.guartor_ext_rating_cd) as guartor_ext_rating_cd -- 保证人外部评级代码
    ,nvl(n.guartor_intnal_rating_dt, o.guartor_intnal_rating_dt) as guartor_intnal_rating_dt -- 保证人内部评级日期
    ,nvl(n.guartor_intnal_rating_cd, o.guartor_intnal_rating_cd) as guartor_intnal_rating_cd -- 保证人内部评级代码
    ,nvl(n.guartor_ownsp_type_cd, o.guartor_ownsp_type_cd) as guartor_ownsp_type_cd -- 保证人所有制类型代码
    ,nvl(n.guartor_net_asset, o.guartor_net_asset) as guartor_net_asset -- 保证人净资产
    ,nvl(n.net_asset_curr_cd, o.net_asset_curr_cd) as net_asset_curr_cd -- 净资产币种代码
    ,nvl(n.guar_insure_policy_num, o.guar_insure_policy_num) as guar_insure_policy_num -- 保证保险保单号码
    ,nvl(n.guar_aim_cd, o.guar_aim_cd) as guar_aim_cd -- 保证目的代码
    ,nvl(n.resdnt_flg, o.resdnt_flg) as resdnt_flg -- 居民标志
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.last_update_dt, o.last_update_dt) as last_update_dt -- 最后更新日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,case when
            n.col_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.col_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.col_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_guar_info_icmsf1_tm n
    full join (select * from ${iml_schema}.ast_col_guar_info_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.col_id = n.col_id
            and o.lp_id = n.lp_id
where (
        o.col_id is null
        and o.lp_id is null
    )
    or (
        n.col_id is null
        and n.lp_id is null
    )
    or (
        o.col_name <> n.col_name
        or o.col_type_cd <> n.col_type_cd
        or o.guar_guar_form_cd <> n.guar_guar_form_cd
        or o.guar_way_cd <> n.guar_way_cd
        or o.guar_status_cd <> n.guar_status_cd
        or o.guar_amt <> n.guar_amt
        or o.guar_curr_cd <> n.guar_curr_cd
        or o.guar_corp_margin_amt <> n.guar_corp_margin_amt
        or o.stage_guar_flg <> n.stage_guar_flg
        or o.estim_org_name <> n.estim_org_name
        or o.estim_val <> n.estim_val
        or o.evltion_dt <> n.evltion_dt
        or o.rel_esat_cert_id <> n.rel_esat_cert_id
        or o.rel_esat_arch_area <> n.rel_esat_arch_area
        or o.mtg_addr <> n.mtg_addr
        or o.log_id <> n.log_id
        or o.log_type_cd <> n.log_type_cd
        or o.log_amt <> n.log_amt
        or o.log_curr_cd <> n.log_curr_cd
        or o.log_issue_cty_cd <> n.log_issue_cty_cd
        or o.open_org_name <> n.open_org_name
        or o.open_org_type_cd <> n.open_org_type_cd
        or o.irevbl_flg <> n.irevbl_flg
        or o.finc_turn_margin_col_id <> n.finc_turn_margin_col_id
        or o.guartor_type_cd <> n.guartor_type_cd
        or o.guartor_id <> n.guartor_id
        or o.guartor_name <> n.guartor_name
        or o.guartor_cert_type_cd <> n.guartor_cert_type_cd
        or o.guartor_cert_no <> n.guartor_cert_no
        or o.guartor_guar_indep_cd <> n.guartor_guar_indep_cd
        or o.guartor_rgst_cty_cd <> n.guartor_rgst_cty_cd
        or o.guartor_rgst_ext_rating_cd <> n.guartor_rgst_ext_rating_cd
        or o.guartor_ext_rating_dt <> n.guartor_ext_rating_dt
        or o.guartor_ext_rating_cd <> n.guartor_ext_rating_cd
        or o.guartor_intnal_rating_dt <> n.guartor_intnal_rating_dt
        or o.guartor_intnal_rating_cd <> n.guartor_intnal_rating_cd
        or o.guartor_ownsp_type_cd <> n.guartor_ownsp_type_cd
        or o.guartor_net_asset <> n.guartor_net_asset
        or o.net_asset_curr_cd <> n.net_asset_curr_cd
        or o.guar_insure_policy_num <> n.guar_insure_policy_num
        or o.guar_aim_cd <> n.guar_aim_cd
        or o.resdnt_flg <> n.resdnt_flg
        or o.remark <> n.remark
        or o.rgst_dt <> n.rgst_dt
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.last_update_dt <> n.last_update_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_col_guar_info_icmsf1_cl(
            col_id -- 押品编号
    ,lp_id -- 法人编号
    ,col_name -- 押品名称
    ,col_type_cd -- 押品类型代码
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_way_cd -- 担保方式代码
    ,guar_status_cd -- 担保状态代码
    ,guar_amt -- 担保金额
    ,guar_curr_cd -- 担保币种代码
    ,guar_corp_margin_amt -- 担保公司保证金金额
    ,stage_guar_flg -- 阶段性担保标志
    ,estim_org_name -- 评估机构名称
    ,estim_val -- 评估价值
    ,evltion_dt -- 估值日期
    ,rel_esat_cert_id -- 不动产证号
    ,rel_esat_arch_area -- 不动产建筑面积
    ,mtg_addr -- 抵押物地址
    ,log_id -- 保函编号
    ,log_type_cd -- 保函类型代码
    ,log_amt -- 保函金额
    ,log_curr_cd -- 保函币种代码
    ,log_issue_cty_cd -- 保函开证国家代码
    ,open_org_name -- 开立机构名称
    ,open_org_type_cd -- 开立机构类型代码
    ,irevbl_flg -- 不可撤销标志
    ,finc_turn_margin_col_id -- 理财转保证金押品编号
    ,guartor_type_cd -- 保证人类型代码
    ,guartor_id -- 保证人编号
    ,guartor_name -- 保证人名称
    ,guartor_cert_type_cd -- 保证人证件类型代码
    ,guartor_cert_no -- 保证人证件号码
    ,guartor_guar_indep_cd -- 保证人担保独立性代码
    ,guartor_rgst_cty_cd -- 保证人注册地国家代码
    ,guartor_rgst_ext_rating_cd -- 保证人注册地外部评级代码
    ,guartor_ext_rating_dt -- 保证人外部评级日期
    ,guartor_ext_rating_cd -- 保证人外部评级代码
    ,guartor_intnal_rating_dt -- 保证人内部评级日期
    ,guartor_intnal_rating_cd -- 保证人内部评级代码
    ,guartor_ownsp_type_cd -- 保证人所有制类型代码
    ,guartor_net_asset -- 保证人净资产
    ,net_asset_curr_cd -- 净资产币种代码
    ,guar_insure_policy_num -- 保证保险保单号码
    ,guar_aim_cd -- 保证目的代码
    ,resdnt_flg -- 居民标志
    ,remark -- 备注
    ,rgst_dt -- 登记日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,last_update_dt -- 最后更新日期
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
        into ${iml_schema}.ast_col_guar_info_icmsf1_op(
            col_id -- 押品编号
    ,lp_id -- 法人编号
    ,col_name -- 押品名称
    ,col_type_cd -- 押品类型代码
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_way_cd -- 担保方式代码
    ,guar_status_cd -- 担保状态代码
    ,guar_amt -- 担保金额
    ,guar_curr_cd -- 担保币种代码
    ,guar_corp_margin_amt -- 担保公司保证金金额
    ,stage_guar_flg -- 阶段性担保标志
    ,estim_org_name -- 评估机构名称
    ,estim_val -- 评估价值
    ,evltion_dt -- 估值日期
    ,rel_esat_cert_id -- 不动产证号
    ,rel_esat_arch_area -- 不动产建筑面积
    ,mtg_addr -- 抵押物地址
    ,log_id -- 保函编号
    ,log_type_cd -- 保函类型代码
    ,log_amt -- 保函金额
    ,log_curr_cd -- 保函币种代码
    ,log_issue_cty_cd -- 保函开证国家代码
    ,open_org_name -- 开立机构名称
    ,open_org_type_cd -- 开立机构类型代码
    ,irevbl_flg -- 不可撤销标志
    ,finc_turn_margin_col_id -- 理财转保证金押品编号
    ,guartor_type_cd -- 保证人类型代码
    ,guartor_id -- 保证人编号
    ,guartor_name -- 保证人名称
    ,guartor_cert_type_cd -- 保证人证件类型代码
    ,guartor_cert_no -- 保证人证件号码
    ,guartor_guar_indep_cd -- 保证人担保独立性代码
    ,guartor_rgst_cty_cd -- 保证人注册地国家代码
    ,guartor_rgst_ext_rating_cd -- 保证人注册地外部评级代码
    ,guartor_ext_rating_dt -- 保证人外部评级日期
    ,guartor_ext_rating_cd -- 保证人外部评级代码
    ,guartor_intnal_rating_dt -- 保证人内部评级日期
    ,guartor_intnal_rating_cd -- 保证人内部评级代码
    ,guartor_ownsp_type_cd -- 保证人所有制类型代码
    ,guartor_net_asset -- 保证人净资产
    ,net_asset_curr_cd -- 净资产币种代码
    ,guar_insure_policy_num -- 保证保险保单号码
    ,guar_aim_cd -- 保证目的代码
    ,resdnt_flg -- 居民标志
    ,remark -- 备注
    ,rgst_dt -- 登记日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,last_update_dt -- 最后更新日期
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
    o.col_id -- 押品编号
    ,o.lp_id -- 法人编号
    ,o.col_name -- 押品名称
    ,o.col_type_cd -- 押品类型代码
    ,o.guar_guar_form_cd -- 保证担保形式代码
    ,o.guar_way_cd -- 担保方式代码
    ,o.guar_status_cd -- 担保状态代码
    ,o.guar_amt -- 担保金额
    ,o.guar_curr_cd -- 担保币种代码
    ,o.guar_corp_margin_amt -- 担保公司保证金金额
    ,o.stage_guar_flg -- 阶段性担保标志
    ,o.estim_org_name -- 评估机构名称
    ,o.estim_val -- 评估价值
    ,o.evltion_dt -- 估值日期
    ,o.rel_esat_cert_id -- 不动产证号
    ,o.rel_esat_arch_area -- 不动产建筑面积
    ,o.mtg_addr -- 抵押物地址
    ,o.log_id -- 保函编号
    ,o.log_type_cd -- 保函类型代码
    ,o.log_amt -- 保函金额
    ,o.log_curr_cd -- 保函币种代码
    ,o.log_issue_cty_cd -- 保函开证国家代码
    ,o.open_org_name -- 开立机构名称
    ,o.open_org_type_cd -- 开立机构类型代码
    ,o.irevbl_flg -- 不可撤销标志
    ,o.finc_turn_margin_col_id -- 理财转保证金押品编号
    ,o.guartor_type_cd -- 保证人类型代码
    ,o.guartor_id -- 保证人编号
    ,o.guartor_name -- 保证人名称
    ,o.guartor_cert_type_cd -- 保证人证件类型代码
    ,o.guartor_cert_no -- 保证人证件号码
    ,o.guartor_guar_indep_cd -- 保证人担保独立性代码
    ,o.guartor_rgst_cty_cd -- 保证人注册地国家代码
    ,o.guartor_rgst_ext_rating_cd -- 保证人注册地外部评级代码
    ,o.guartor_ext_rating_dt -- 保证人外部评级日期
    ,o.guartor_ext_rating_cd -- 保证人外部评级代码
    ,o.guartor_intnal_rating_dt -- 保证人内部评级日期
    ,o.guartor_intnal_rating_cd -- 保证人内部评级代码
    ,o.guartor_ownsp_type_cd -- 保证人所有制类型代码
    ,o.guartor_net_asset -- 保证人净资产
    ,o.net_asset_curr_cd -- 净资产币种代码
    ,o.guar_insure_policy_num -- 保证保险保单号码
    ,o.guar_aim_cd -- 保证目的代码
    ,o.resdnt_flg -- 居民标志
    ,o.remark -- 备注
    ,o.rgst_dt -- 登记日期
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.last_update_dt -- 最后更新日期
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
from ${iml_schema}.ast_col_guar_info_icmsf1_bk o
    left join ${iml_schema}.ast_col_guar_info_icmsf1_op n
        on
            o.col_id = n.col_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ast_col_guar_info_icmsf1_cl d
        on
            o.col_id = d.col_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ast_col_guar_info;
--alter table ${iml_schema}.ast_col_guar_info truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ast_col_guar_info') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ast_col_guar_info drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_guar_info modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ast_col_guar_info exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.ast_col_guar_info_icmsf1_cl;
alter table ${iml_schema}.ast_col_guar_info exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.ast_col_guar_info_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_guar_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ast_col_guar_info_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_guar_info_icmsf1_op purge;
drop table ${iml_schema}.ast_col_guar_info_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ast_col_guar_info_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_guar_info', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
