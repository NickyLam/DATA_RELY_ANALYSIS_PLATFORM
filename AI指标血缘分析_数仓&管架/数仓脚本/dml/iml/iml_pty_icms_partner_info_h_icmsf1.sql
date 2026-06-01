/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_icms_partner_info_h_icmsf1
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
alter table ${iml_schema}.pty_icms_partner_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_icms_partner_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_icms_partner_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_icms_partner_info_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_icms_partner_info_h_icmsf1_op purge;
drop table ${iml_schema}.pty_icms_partner_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_icms_partner_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,partner_id -- 合作方编号
    ,partner_name -- 合作方名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,legal_rep_name -- 法定代表人姓名
    ,legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,legal_rep_cert_no -- 法定代表人证件号码
    ,phys_addr -- 物理地址
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,crdt_lmt -- 授信额度
    ,co_start_dt -- 合作开始日期
    ,co_end_dt -- 合作结束日期
    ,coprator_char_cd -- 合作商性质代码
    ,coprator_proj_type_cd -- 合作商项目类型代码
    ,coprator_type_cd -- 合作商类型代码
    ,partner_status_cd -- 合作方状态代码
    ,partner_cotas_name -- 合作方联系人姓名
    ,higt_co_lmt -- 最高合作额度
    ,co_mon_tenor -- 合作月期限
    ,cust_phone -- 客户联系电话
    ,input_integy_flg -- 已完善标志
    ,prep_appl_avg_lmt -- 拟申请平均额度
    ,fit_org_id -- 适用机构编号
    ,invest_main_type_cd -- 投资主体类型代码
    ,hold_type_cd -- 控股类型代码
    ,indus_type_cd -- 行业类型代码
    ,indus_name -- 行业名称
    ,obtain_emply_number -- 从业人数
    ,asset_tot -- 资产总额
    ,bus_inco -- 营业收入
    ,corp_found_dt -- 企业成立日期
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,tax_num -- 纳税人识别号
    ,orgnz_rgst_dt -- 组织机构登记日期
    ,orgnz_rgst_exp_dt -- 组织机构登记到期日期
    ,bus_lics_rgst_dt -- 营业执照登记日期
    ,bus_lics_exp_dt -- 营业执照到期日期
    ,basic_dep_open_acct_lics_id -- 基本存款账户开户许可证编号
    ,fin_dept_princ -- 财务部负责人
    ,fin_dept_cotas -- 财务部联系人
    ,fin_dept_cotas_work_tel -- 财务部联系人单位电话
    ,fin_dept_cont_mobile_no -- 财务部联系手机号码
    ,corp_char_cd -- 单位性质代码
    ,mailbox -- 邮箱
    ,cust_and_hxb_incid_rela_cd -- 客户与我行关联关系代码
    ,intnal_rating_rest_cd -- 内部评级结果代码
    ,crdt_rating_dt -- 信用评定日期
    ,guartor_flg -- 担保人标志
    ,guar_ratio -- 担保比例
    ,higt_guar_amt -- 最高担保金额
    ,rgst_teller_id -- 登记柜员编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_icms_partner_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.pty_icms_partner_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_icms_partner_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.pty_icms_partner_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_icms_partner_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_customer_partner-
insert into ${iml_schema}.pty_icms_partner_info_h_icmsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,partner_id -- 合作方编号
    ,partner_name -- 合作方名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,legal_rep_name -- 法定代表人姓名
    ,legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,legal_rep_cert_no -- 法定代表人证件号码
    ,phys_addr -- 物理地址
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,crdt_lmt -- 授信额度
    ,co_start_dt -- 合作开始日期
    ,co_end_dt -- 合作结束日期
    ,coprator_char_cd -- 合作商性质代码
    ,coprator_proj_type_cd -- 合作商项目类型代码
    ,coprator_type_cd -- 合作商类型代码
    ,partner_status_cd -- 合作方状态代码
    ,partner_cotas_name -- 合作方联系人姓名
    ,higt_co_lmt -- 最高合作额度
    ,co_mon_tenor -- 合作月期限
    ,cust_phone -- 客户联系电话
    ,input_integy_flg -- 已完善标志
    ,prep_appl_avg_lmt -- 拟申请平均额度
    ,fit_org_id -- 适用机构编号
    ,invest_main_type_cd -- 投资主体类型代码
    ,hold_type_cd -- 控股类型代码
    ,indus_type_cd -- 行业类型代码
    ,indus_name -- 行业名称
    ,obtain_emply_number -- 从业人数
    ,asset_tot -- 资产总额
    ,bus_inco -- 营业收入
    ,corp_found_dt -- 企业成立日期
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,tax_num -- 纳税人识别号
    ,orgnz_rgst_dt -- 组织机构登记日期
    ,orgnz_rgst_exp_dt -- 组织机构登记到期日期
    ,bus_lics_rgst_dt -- 营业执照登记日期
    ,bus_lics_exp_dt -- 营业执照到期日期
    ,basic_dep_open_acct_lics_id -- 基本存款账户开户许可证编号
    ,fin_dept_princ -- 财务部负责人
    ,fin_dept_cotas -- 财务部联系人
    ,fin_dept_cotas_work_tel -- 财务部联系人单位电话
    ,fin_dept_cont_mobile_no -- 财务部联系手机号码
    ,corp_char_cd -- 单位性质代码
    ,mailbox -- 邮箱
    ,cust_and_hxb_incid_rela_cd -- 客户与我行关联关系代码
    ,intnal_rating_rest_cd -- 内部评级结果代码
    ,crdt_rating_dt -- 信用评定日期
    ,guartor_flg -- 担保人标志
    ,guar_ratio -- 担保比例
    ,higt_guar_amt -- 最高担保金额
    ,rgst_teller_id -- 登记柜员编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
     '701001'||P1.PARTNERID -- 当事人编号
    , '9999' -- 法人编号
    ,P1.PARTNERID -- 合作方编号
    ,P1.PARTNERNAME -- 合作方名称
    ,nvl(trim(P1.CERTTYPE),'0000') -- 证件类型代码
    ,P1.CERTID -- 证件号码
    ,P1.FICTITIOUSPERSON -- 法定代表人姓名
    ,nvl(trim(P1.FICTITIOUSCERTTYPE),'0000') -- 法定代表人证件类型代码
    ,P1.FICTITIOUSCERT -- 法定代表人证件号码
    ,P1.ADDRESS -- 物理地址
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.APPLYTOTALAMT -- 授信额度
    ,P1.COOPENDDATE -- 合作开始日期
    ,P1.COOPSTARTDATE -- 合作结束日期
    ,nvl(trim(P1.PARTNERTYPE),'-') -- 合作商性质代码
    ,nvl(trim(P1.PROJECTTYPE),'104') -- 合作商项目类型代码
    ,nvl(trim(P1.PARTNERTYPESUB),'0000') -- 合作商类型代码
    ,nvl(trim(P1.STATUS),'-') -- 合作方状态代码
    ,P1.BUSINESSMANAGER -- 合作方联系人姓名
    ,P1.MAXCREDITLIMIT -- 最高合作额度
    ,P1.COOPTERM -- 合作月期限
    ,P1.OFFICETEL -- 客户联系电话
    ,decode(P1.COMPLETEFLAG,'2','0',' ','-',P1.COMPLETEFLAG) -- 已完善标志
    ,P1.APPLYAVGAMT -- 拟申请平均额度
    ,P1.USERANGEORG -- 适用机构编号
    ,nvl(trim(P1.INVESTTYPE),'8') -- 投资主体类型代码
    ,nvl(trim(P1.COMHOLDTYPE),'00000') -- 控股类型代码
    ,nvl(trim(P1.INDUSTRYTYPE),'-') -- 行业类型代码
    ,P1.INDUSTRYNAME -- 行业名称
    ,P1.WORKNUM -- 从业人数
    ,P1.ASSETSUM -- 资产总额
    ,P1.BUSINESSINCOME -- 营业收入
    ,P1.COMPSTARTDATE -- 企业成立日期
    ,P1.ORGCODE -- 统一社会信用代码
    ,P1.TAXPAYERIDENTINO -- 纳税人识别号
    ,P1.ORGCODESTARTDATE -- 组织机构登记日期
    ,P1.ORGCODEENDDATE -- 组织机构登记到期日期
    ,P1.BUSINESSLICENCESTARTDATE -- 营业执照登记日期
    ,P1.BUSINESSLICENCEENDDATE -- 营业执照到期日期
    ,P1.BASACCLICENCE -- 基本存款账户开户许可证编号
    ,P1.FINAPRINCIPAL -- 财务部负责人
    ,P1.FINACONTACTPEOPLE -- 财务部联系人
    ,P1.FINACOMTEL -- 财务部联系人单位电话
    ,P1.FINAMOBILETEL -- 财务部联系手机号码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.UNITTYPE END -- 单位性质代码
    ,P1.EMAIL -- 邮箱
    ,nvl(trim(P1.CUSBANKREL),'99999') -- 客户与我行关联关系代码
    ,nvl(trim(P1.CREDITLEVEL),'-') -- 内部评级结果代码
    ,P1.CREDITLEVELDATE -- 信用评定日期
    ,nvl(trim(P1.ISGUARANTEE),'-') -- 担保人标志
    ,P1.GUARANTEEPROPORTION -- 担保比例
    ,P1.MAXGUARANTEEAMOUNT -- 最高担保金额
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_customer_partner' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_customer_partner p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.UNITTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_CUSTOMER_PARTNER'
        AND R1.SRC_FIELD_EN_NAME= 'UNITTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PTY_ICMS_PARTNER_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CORP_CHAR_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_icms_partner_info_h_icmsf1_tm 
  	                                group by 
  	                                        party_id
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
        into ${iml_schema}.pty_icms_partner_info_h_icmsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,partner_id -- 合作方编号
    ,partner_name -- 合作方名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,legal_rep_name -- 法定代表人姓名
    ,legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,legal_rep_cert_no -- 法定代表人证件号码
    ,phys_addr -- 物理地址
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,crdt_lmt -- 授信额度
    ,co_start_dt -- 合作开始日期
    ,co_end_dt -- 合作结束日期
    ,coprator_char_cd -- 合作商性质代码
    ,coprator_proj_type_cd -- 合作商项目类型代码
    ,coprator_type_cd -- 合作商类型代码
    ,partner_status_cd -- 合作方状态代码
    ,partner_cotas_name -- 合作方联系人姓名
    ,higt_co_lmt -- 最高合作额度
    ,co_mon_tenor -- 合作月期限
    ,cust_phone -- 客户联系电话
    ,input_integy_flg -- 已完善标志
    ,prep_appl_avg_lmt -- 拟申请平均额度
    ,fit_org_id -- 适用机构编号
    ,invest_main_type_cd -- 投资主体类型代码
    ,hold_type_cd -- 控股类型代码
    ,indus_type_cd -- 行业类型代码
    ,indus_name -- 行业名称
    ,obtain_emply_number -- 从业人数
    ,asset_tot -- 资产总额
    ,bus_inco -- 营业收入
    ,corp_found_dt -- 企业成立日期
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,tax_num -- 纳税人识别号
    ,orgnz_rgst_dt -- 组织机构登记日期
    ,orgnz_rgst_exp_dt -- 组织机构登记到期日期
    ,bus_lics_rgst_dt -- 营业执照登记日期
    ,bus_lics_exp_dt -- 营业执照到期日期
    ,basic_dep_open_acct_lics_id -- 基本存款账户开户许可证编号
    ,fin_dept_princ -- 财务部负责人
    ,fin_dept_cotas -- 财务部联系人
    ,fin_dept_cotas_work_tel -- 财务部联系人单位电话
    ,fin_dept_cont_mobile_no -- 财务部联系手机号码
    ,corp_char_cd -- 单位性质代码
    ,mailbox -- 邮箱
    ,cust_and_hxb_incid_rela_cd -- 客户与我行关联关系代码
    ,intnal_rating_rest_cd -- 内部评级结果代码
    ,crdt_rating_dt -- 信用评定日期
    ,guartor_flg -- 担保人标志
    ,guar_ratio -- 担保比例
    ,higt_guar_amt -- 最高担保金额
    ,rgst_teller_id -- 登记柜员编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_icms_partner_info_h_icmsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,partner_id -- 合作方编号
    ,partner_name -- 合作方名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,legal_rep_name -- 法定代表人姓名
    ,legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,legal_rep_cert_no -- 法定代表人证件号码
    ,phys_addr -- 物理地址
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,crdt_lmt -- 授信额度
    ,co_start_dt -- 合作开始日期
    ,co_end_dt -- 合作结束日期
    ,coprator_char_cd -- 合作商性质代码
    ,coprator_proj_type_cd -- 合作商项目类型代码
    ,coprator_type_cd -- 合作商类型代码
    ,partner_status_cd -- 合作方状态代码
    ,partner_cotas_name -- 合作方联系人姓名
    ,higt_co_lmt -- 最高合作额度
    ,co_mon_tenor -- 合作月期限
    ,cust_phone -- 客户联系电话
    ,input_integy_flg -- 已完善标志
    ,prep_appl_avg_lmt -- 拟申请平均额度
    ,fit_org_id -- 适用机构编号
    ,invest_main_type_cd -- 投资主体类型代码
    ,hold_type_cd -- 控股类型代码
    ,indus_type_cd -- 行业类型代码
    ,indus_name -- 行业名称
    ,obtain_emply_number -- 从业人数
    ,asset_tot -- 资产总额
    ,bus_inco -- 营业收入
    ,corp_found_dt -- 企业成立日期
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,tax_num -- 纳税人识别号
    ,orgnz_rgst_dt -- 组织机构登记日期
    ,orgnz_rgst_exp_dt -- 组织机构登记到期日期
    ,bus_lics_rgst_dt -- 营业执照登记日期
    ,bus_lics_exp_dt -- 营业执照到期日期
    ,basic_dep_open_acct_lics_id -- 基本存款账户开户许可证编号
    ,fin_dept_princ -- 财务部负责人
    ,fin_dept_cotas -- 财务部联系人
    ,fin_dept_cotas_work_tel -- 财务部联系人单位电话
    ,fin_dept_cont_mobile_no -- 财务部联系手机号码
    ,corp_char_cd -- 单位性质代码
    ,mailbox -- 邮箱
    ,cust_and_hxb_incid_rela_cd -- 客户与我行关联关系代码
    ,intnal_rating_rest_cd -- 内部评级结果代码
    ,crdt_rating_dt -- 信用评定日期
    ,guartor_flg -- 担保人标志
    ,guar_ratio -- 担保比例
    ,higt_guar_amt -- 最高担保金额
    ,rgst_teller_id -- 登记柜员编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.partner_id, o.partner_id) as partner_id -- 合作方编号
    ,nvl(n.partner_name, o.partner_name) as partner_name -- 合作方名称
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.legal_rep_name, o.legal_rep_name) as legal_rep_name -- 法定代表人姓名
    ,nvl(n.legal_rep_cert_type_cd, o.legal_rep_cert_type_cd) as legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,nvl(n.legal_rep_cert_no, o.legal_rep_cert_no) as legal_rep_cert_no -- 法定代表人证件号码
    ,nvl(n.phys_addr, o.phys_addr) as phys_addr -- 物理地址
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.crdt_lmt, o.crdt_lmt) as crdt_lmt -- 授信额度
    ,nvl(n.co_start_dt, o.co_start_dt) as co_start_dt -- 合作开始日期
    ,nvl(n.co_end_dt, o.co_end_dt) as co_end_dt -- 合作结束日期
    ,nvl(n.coprator_char_cd, o.coprator_char_cd) as coprator_char_cd -- 合作商性质代码
    ,nvl(n.coprator_proj_type_cd, o.coprator_proj_type_cd) as coprator_proj_type_cd -- 合作商项目类型代码
    ,nvl(n.coprator_type_cd, o.coprator_type_cd) as coprator_type_cd -- 合作商类型代码
    ,nvl(n.partner_status_cd, o.partner_status_cd) as partner_status_cd -- 合作方状态代码
    ,nvl(n.partner_cotas_name, o.partner_cotas_name) as partner_cotas_name -- 合作方联系人姓名
    ,nvl(n.higt_co_lmt, o.higt_co_lmt) as higt_co_lmt -- 最高合作额度
    ,nvl(n.co_mon_tenor, o.co_mon_tenor) as co_mon_tenor -- 合作月期限
    ,nvl(n.cust_phone, o.cust_phone) as cust_phone -- 客户联系电话
    ,nvl(n.input_integy_flg, o.input_integy_flg) as input_integy_flg -- 已完善标志
    ,nvl(n.prep_appl_avg_lmt, o.prep_appl_avg_lmt) as prep_appl_avg_lmt -- 拟申请平均额度
    ,nvl(n.fit_org_id, o.fit_org_id) as fit_org_id -- 适用机构编号
    ,nvl(n.invest_main_type_cd, o.invest_main_type_cd) as invest_main_type_cd -- 投资主体类型代码
    ,nvl(n.hold_type_cd, o.hold_type_cd) as hold_type_cd -- 控股类型代码
    ,nvl(n.indus_type_cd, o.indus_type_cd) as indus_type_cd -- 行业类型代码
    ,nvl(n.indus_name, o.indus_name) as indus_name -- 行业名称
    ,nvl(n.obtain_emply_number, o.obtain_emply_number) as obtain_emply_number -- 从业人数
    ,nvl(n.asset_tot, o.asset_tot) as asset_tot -- 资产总额
    ,nvl(n.bus_inco, o.bus_inco) as bus_inco -- 营业收入
    ,nvl(n.corp_found_dt, o.corp_found_dt) as corp_found_dt -- 企业成立日期
    ,nvl(n.unify_soci_crdt_cd, o.unify_soci_crdt_cd) as unify_soci_crdt_cd -- 统一社会信用代码
    ,nvl(n.tax_num, o.tax_num) as tax_num -- 纳税人识别号
    ,nvl(n.orgnz_rgst_dt, o.orgnz_rgst_dt) as orgnz_rgst_dt -- 组织机构登记日期
    ,nvl(n.orgnz_rgst_exp_dt, o.orgnz_rgst_exp_dt) as orgnz_rgst_exp_dt -- 组织机构登记到期日期
    ,nvl(n.bus_lics_rgst_dt, o.bus_lics_rgst_dt) as bus_lics_rgst_dt -- 营业执照登记日期
    ,nvl(n.bus_lics_exp_dt, o.bus_lics_exp_dt) as bus_lics_exp_dt -- 营业执照到期日期
    ,nvl(n.basic_dep_open_acct_lics_id, o.basic_dep_open_acct_lics_id) as basic_dep_open_acct_lics_id -- 基本存款账户开户许可证编号
    ,nvl(n.fin_dept_princ, o.fin_dept_princ) as fin_dept_princ -- 财务部负责人
    ,nvl(n.fin_dept_cotas, o.fin_dept_cotas) as fin_dept_cotas -- 财务部联系人
    ,nvl(n.fin_dept_cotas_work_tel, o.fin_dept_cotas_work_tel) as fin_dept_cotas_work_tel -- 财务部联系人单位电话
    ,nvl(n.fin_dept_cont_mobile_no, o.fin_dept_cont_mobile_no) as fin_dept_cont_mobile_no -- 财务部联系手机号码
    ,nvl(n.corp_char_cd, o.corp_char_cd) as corp_char_cd -- 单位性质代码
    ,nvl(n.mailbox, o.mailbox) as mailbox -- 邮箱
    ,nvl(n.cust_and_hxb_incid_rela_cd, o.cust_and_hxb_incid_rela_cd) as cust_and_hxb_incid_rela_cd -- 客户与我行关联关系代码
    ,nvl(n.intnal_rating_rest_cd, o.intnal_rating_rest_cd) as intnal_rating_rest_cd -- 内部评级结果代码
    ,nvl(n.crdt_rating_dt, o.crdt_rating_dt) as crdt_rating_dt -- 信用评定日期
    ,nvl(n.guartor_flg, o.guartor_flg) as guartor_flg -- 担保人标志
    ,nvl(n.guar_ratio, o.guar_ratio) as guar_ratio -- 担保比例
    ,nvl(n.higt_guar_amt, o.higt_guar_amt) as higt_guar_amt -- 最高担保金额
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,case when
            n.party_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_icms_partner_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.pty_icms_partner_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
where (
        o.party_id is null
        and o.lp_id is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
    )
    or (
        o.partner_id <> n.partner_id
        or o.partner_name <> n.partner_name
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.legal_rep_name <> n.legal_rep_name
        or o.legal_rep_cert_type_cd <> n.legal_rep_cert_type_cd
        or o.legal_rep_cert_no <> n.legal_rep_cert_no
        or o.phys_addr <> n.phys_addr
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.crdt_lmt <> n.crdt_lmt
        or o.co_start_dt <> n.co_start_dt
        or o.co_end_dt <> n.co_end_dt
        or o.coprator_char_cd <> n.coprator_char_cd
        or o.coprator_proj_type_cd <> n.coprator_proj_type_cd
        or o.coprator_type_cd <> n.coprator_type_cd
        or o.partner_status_cd <> n.partner_status_cd
        or o.partner_cotas_name <> n.partner_cotas_name
        or o.higt_co_lmt <> n.higt_co_lmt
        or o.co_mon_tenor <> n.co_mon_tenor
        or o.cust_phone <> n.cust_phone
        or o.input_integy_flg <> n.input_integy_flg
        or o.prep_appl_avg_lmt <> n.prep_appl_avg_lmt
        or o.fit_org_id <> n.fit_org_id
        or o.invest_main_type_cd <> n.invest_main_type_cd
        or o.hold_type_cd <> n.hold_type_cd
        or o.indus_type_cd <> n.indus_type_cd
        or o.indus_name <> n.indus_name
        or o.obtain_emply_number <> n.obtain_emply_number
        or o.asset_tot <> n.asset_tot
        or o.bus_inco <> n.bus_inco
        or o.corp_found_dt <> n.corp_found_dt
        or o.unify_soci_crdt_cd <> n.unify_soci_crdt_cd
        or o.tax_num <> n.tax_num
        or o.orgnz_rgst_dt <> n.orgnz_rgst_dt
        or o.orgnz_rgst_exp_dt <> n.orgnz_rgst_exp_dt
        or o.bus_lics_rgst_dt <> n.bus_lics_rgst_dt
        or o.bus_lics_exp_dt <> n.bus_lics_exp_dt
        or o.basic_dep_open_acct_lics_id <> n.basic_dep_open_acct_lics_id
        or o.fin_dept_princ <> n.fin_dept_princ
        or o.fin_dept_cotas <> n.fin_dept_cotas
        or o.fin_dept_cotas_work_tel <> n.fin_dept_cotas_work_tel
        or o.fin_dept_cont_mobile_no <> n.fin_dept_cont_mobile_no
        or o.corp_char_cd <> n.corp_char_cd
        or o.mailbox <> n.mailbox
        or o.cust_and_hxb_incid_rela_cd <> n.cust_and_hxb_incid_rela_cd
        or o.intnal_rating_rest_cd <> n.intnal_rating_rest_cd
        or o.crdt_rating_dt <> n.crdt_rating_dt
        or o.guartor_flg <> n.guartor_flg
        or o.guar_ratio <> n.guar_ratio
        or o.higt_guar_amt <> n.higt_guar_amt
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.final_update_dt <> n.final_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_icms_partner_info_h_icmsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,partner_id -- 合作方编号
    ,partner_name -- 合作方名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,legal_rep_name -- 法定代表人姓名
    ,legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,legal_rep_cert_no -- 法定代表人证件号码
    ,phys_addr -- 物理地址
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,crdt_lmt -- 授信额度
    ,co_start_dt -- 合作开始日期
    ,co_end_dt -- 合作结束日期
    ,coprator_char_cd -- 合作商性质代码
    ,coprator_proj_type_cd -- 合作商项目类型代码
    ,coprator_type_cd -- 合作商类型代码
    ,partner_status_cd -- 合作方状态代码
    ,partner_cotas_name -- 合作方联系人姓名
    ,higt_co_lmt -- 最高合作额度
    ,co_mon_tenor -- 合作月期限
    ,cust_phone -- 客户联系电话
    ,input_integy_flg -- 已完善标志
    ,prep_appl_avg_lmt -- 拟申请平均额度
    ,fit_org_id -- 适用机构编号
    ,invest_main_type_cd -- 投资主体类型代码
    ,hold_type_cd -- 控股类型代码
    ,indus_type_cd -- 行业类型代码
    ,indus_name -- 行业名称
    ,obtain_emply_number -- 从业人数
    ,asset_tot -- 资产总额
    ,bus_inco -- 营业收入
    ,corp_found_dt -- 企业成立日期
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,tax_num -- 纳税人识别号
    ,orgnz_rgst_dt -- 组织机构登记日期
    ,orgnz_rgst_exp_dt -- 组织机构登记到期日期
    ,bus_lics_rgst_dt -- 营业执照登记日期
    ,bus_lics_exp_dt -- 营业执照到期日期
    ,basic_dep_open_acct_lics_id -- 基本存款账户开户许可证编号
    ,fin_dept_princ -- 财务部负责人
    ,fin_dept_cotas -- 财务部联系人
    ,fin_dept_cotas_work_tel -- 财务部联系人单位电话
    ,fin_dept_cont_mobile_no -- 财务部联系手机号码
    ,corp_char_cd -- 单位性质代码
    ,mailbox -- 邮箱
    ,cust_and_hxb_incid_rela_cd -- 客户与我行关联关系代码
    ,intnal_rating_rest_cd -- 内部评级结果代码
    ,crdt_rating_dt -- 信用评定日期
    ,guartor_flg -- 担保人标志
    ,guar_ratio -- 担保比例
    ,higt_guar_amt -- 最高担保金额
    ,rgst_teller_id -- 登记柜员编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_icms_partner_info_h_icmsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,partner_id -- 合作方编号
    ,partner_name -- 合作方名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,legal_rep_name -- 法定代表人姓名
    ,legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,legal_rep_cert_no -- 法定代表人证件号码
    ,phys_addr -- 物理地址
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,crdt_lmt -- 授信额度
    ,co_start_dt -- 合作开始日期
    ,co_end_dt -- 合作结束日期
    ,coprator_char_cd -- 合作商性质代码
    ,coprator_proj_type_cd -- 合作商项目类型代码
    ,coprator_type_cd -- 合作商类型代码
    ,partner_status_cd -- 合作方状态代码
    ,partner_cotas_name -- 合作方联系人姓名
    ,higt_co_lmt -- 最高合作额度
    ,co_mon_tenor -- 合作月期限
    ,cust_phone -- 客户联系电话
    ,input_integy_flg -- 已完善标志
    ,prep_appl_avg_lmt -- 拟申请平均额度
    ,fit_org_id -- 适用机构编号
    ,invest_main_type_cd -- 投资主体类型代码
    ,hold_type_cd -- 控股类型代码
    ,indus_type_cd -- 行业类型代码
    ,indus_name -- 行业名称
    ,obtain_emply_number -- 从业人数
    ,asset_tot -- 资产总额
    ,bus_inco -- 营业收入
    ,corp_found_dt -- 企业成立日期
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,tax_num -- 纳税人识别号
    ,orgnz_rgst_dt -- 组织机构登记日期
    ,orgnz_rgst_exp_dt -- 组织机构登记到期日期
    ,bus_lics_rgst_dt -- 营业执照登记日期
    ,bus_lics_exp_dt -- 营业执照到期日期
    ,basic_dep_open_acct_lics_id -- 基本存款账户开户许可证编号
    ,fin_dept_princ -- 财务部负责人
    ,fin_dept_cotas -- 财务部联系人
    ,fin_dept_cotas_work_tel -- 财务部联系人单位电话
    ,fin_dept_cont_mobile_no -- 财务部联系手机号码
    ,corp_char_cd -- 单位性质代码
    ,mailbox -- 邮箱
    ,cust_and_hxb_incid_rela_cd -- 客户与我行关联关系代码
    ,intnal_rating_rest_cd -- 内部评级结果代码
    ,crdt_rating_dt -- 信用评定日期
    ,guartor_flg -- 担保人标志
    ,guar_ratio -- 担保比例
    ,higt_guar_amt -- 最高担保金额
    ,rgst_teller_id -- 登记柜员编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.lp_id -- 法人编号
    ,o.partner_id -- 合作方编号
    ,o.partner_name -- 合作方名称
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.legal_rep_name -- 法定代表人姓名
    ,o.legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,o.legal_rep_cert_no -- 法定代表人证件号码
    ,o.phys_addr -- 物理地址
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.crdt_lmt -- 授信额度
    ,o.co_start_dt -- 合作开始日期
    ,o.co_end_dt -- 合作结束日期
    ,o.coprator_char_cd -- 合作商性质代码
    ,o.coprator_proj_type_cd -- 合作商项目类型代码
    ,o.coprator_type_cd -- 合作商类型代码
    ,o.partner_status_cd -- 合作方状态代码
    ,o.partner_cotas_name -- 合作方联系人姓名
    ,o.higt_co_lmt -- 最高合作额度
    ,o.co_mon_tenor -- 合作月期限
    ,o.cust_phone -- 客户联系电话
    ,o.input_integy_flg -- 已完善标志
    ,o.prep_appl_avg_lmt -- 拟申请平均额度
    ,o.fit_org_id -- 适用机构编号
    ,o.invest_main_type_cd -- 投资主体类型代码
    ,o.hold_type_cd -- 控股类型代码
    ,o.indus_type_cd -- 行业类型代码
    ,o.indus_name -- 行业名称
    ,o.obtain_emply_number -- 从业人数
    ,o.asset_tot -- 资产总额
    ,o.bus_inco -- 营业收入
    ,o.corp_found_dt -- 企业成立日期
    ,o.unify_soci_crdt_cd -- 统一社会信用代码
    ,o.tax_num -- 纳税人识别号
    ,o.orgnz_rgst_dt -- 组织机构登记日期
    ,o.orgnz_rgst_exp_dt -- 组织机构登记到期日期
    ,o.bus_lics_rgst_dt -- 营业执照登记日期
    ,o.bus_lics_exp_dt -- 营业执照到期日期
    ,o.basic_dep_open_acct_lics_id -- 基本存款账户开户许可证编号
    ,o.fin_dept_princ -- 财务部负责人
    ,o.fin_dept_cotas -- 财务部联系人
    ,o.fin_dept_cotas_work_tel -- 财务部联系人单位电话
    ,o.fin_dept_cont_mobile_no -- 财务部联系手机号码
    ,o.corp_char_cd -- 单位性质代码
    ,o.mailbox -- 邮箱
    ,o.cust_and_hxb_incid_rela_cd -- 客户与我行关联关系代码
    ,o.intnal_rating_rest_cd -- 内部评级结果代码
    ,o.crdt_rating_dt -- 信用评定日期
    ,o.guartor_flg -- 担保人标志
    ,o.guar_ratio -- 担保比例
    ,o.higt_guar_amt -- 最高担保金额
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.final_update_dt -- 最后更新日期
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
from ${iml_schema}.pty_icms_partner_info_h_icmsf1_bk o
    left join ${iml_schema}.pty_icms_partner_info_h_icmsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_icms_partner_info_h_icmsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_icms_partner_info_h;
--alter table ${iml_schema}.pty_icms_partner_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_icms_partner_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_icms_partner_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_icms_partner_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_icms_partner_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.pty_icms_partner_info_h_icmsf1_cl;
alter table ${iml_schema}.pty_icms_partner_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.pty_icms_partner_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_icms_partner_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_icms_partner_info_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_icms_partner_info_h_icmsf1_op purge;
drop table ${iml_schema}.pty_icms_partner_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_icms_partner_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_icms_partner_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
