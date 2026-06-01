/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_xked_pre_loan_appl_info_icmsf1
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
alter table ${iml_schema}.agt_xked_pre_loan_appl_info add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_xked_pre_loan_appl_info partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_tm purge;
drop table ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_op purge;
drop table ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,prod_abbr -- 产品简称
    ,access_chn_id -- 接入渠道编号
    ,loan_tenor -- 贷款期限
    ,appl_amt -- 申请金额
    ,apv_lmt -- 审批额度
    ,apv_appl_dt -- 审批申请日期
    ,apv_end_dt -- 审批结束日期
    ,apv_status_cd -- 审批状态代码
    ,task_status_cd -- 任务状态代码
    ,lp_cust_id -- 法人客户编号
    ,issue_dt -- 签发日期
    ,brwer_cert_exp_dt -- 借款人证件到期日期
    ,resd_local_prov -- 居住所在省份
    ,resd_city -- 居住所在城市
    ,resd_local_rg -- 居住所在区域
    ,resdnt_addr -- 居住地址
    ,career_cd -- 职业代码
    ,nation_cd -- 国籍代码
    ,corp_name -- 企业名称
    ,corp_rgst_dt -- 企业注册日期
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,tax_num -- 纳税人识别号
    ,tax_que_flg -- 税务查询标志
    ,tax_que_auth_flow_num -- 税务查询授权流水号
    ,mang_inco -- 经营收入
    ,corp_size_cd -- 企业规模代码
    ,asset_sum -- 资产合计
    ,data_src_cd -- 数据来源代码
    ,que_appl_type_cd -- 查询申请类型代码
    ,auth_flg -- 授权标志
    ,auth_way_cd -- 授权方式代码
    ,biome_trics -- 生物识别方式代码
    ,auth_dt -- 授权日期
    ,auth_effect_dt -- 授权生效日期
    ,auth_invalid_dt -- 授权失效日期
    ,warn_info -- 预警信息
    ,refuse_rs_descb -- 拒绝原因描述
    ,mang_range -- 经营范围
    ,bus_lics_vp -- 营业执照有效期
    ,rgst_addr -- 注册地址
    ,sm_corp_flg -- 小微企业标志
    ,rgst_org_id -- 登记机构编号
    ,pre_scd_year_sell_inco -- 预测次年销售收入
    ,other_chn_provi_oper_cap -- 其他渠道提供的营运资金
    ,advise_flg -- 通知展业标志
    ,mon_rent_lmt -- 月租金额
    ,corp_in_mons -- 企业入驻月份数
    ,score_val -- 评分分值
    ,obtain_emply_number -- 从业人数
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,indus_type_cd -- 行业类型代码
    ,crdtc_rest_cd -- 征信检验结果代码
    ,cust_mgr_id -- 客户经理编号
    ,belong_brch_org_id -- 所属分行机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_xked_pre_loan_appl_info partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_xked_pre_loan_appl_info partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_xked_pre_loan_appl_info partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_xked_iqp_loan_prior-1
insert into ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,prod_abbr -- 产品简称
    ,access_chn_id -- 接入渠道编号
    ,loan_tenor -- 贷款期限
    ,appl_amt -- 申请金额
    ,apv_lmt -- 审批额度
    ,apv_appl_dt -- 审批申请日期
    ,apv_end_dt -- 审批结束日期
    ,apv_status_cd -- 审批状态代码
    ,task_status_cd -- 任务状态代码
    ,lp_cust_id -- 法人客户编号
    ,issue_dt -- 签发日期
    ,brwer_cert_exp_dt -- 借款人证件到期日期
    ,resd_local_prov -- 居住所在省份
    ,resd_city -- 居住所在城市
    ,resd_local_rg -- 居住所在区域
    ,resdnt_addr -- 居住地址
    ,career_cd -- 职业代码
    ,nation_cd -- 国籍代码
    ,corp_name -- 企业名称
    ,corp_rgst_dt -- 企业注册日期
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,tax_num -- 纳税人识别号
    ,tax_que_flg -- 税务查询标志
    ,tax_que_auth_flow_num -- 税务查询授权流水号
    ,mang_inco -- 经营收入
    ,corp_size_cd -- 企业规模代码
    ,asset_sum -- 资产合计
    ,data_src_cd -- 数据来源代码
    ,que_appl_type_cd -- 查询申请类型代码
    ,auth_flg -- 授权标志
    ,auth_way_cd -- 授权方式代码
    ,biome_trics -- 生物识别方式代码
    ,auth_dt -- 授权日期
    ,auth_effect_dt -- 授权生效日期
    ,auth_invalid_dt -- 授权失效日期
    ,warn_info -- 预警信息
    ,refuse_rs_descb -- 拒绝原因描述
    ,mang_range -- 经营范围
    ,bus_lics_vp -- 营业执照有效期
    ,rgst_addr -- 注册地址
    ,sm_corp_flg -- 小微企业标志
    ,rgst_org_id -- 登记机构编号
    ,pre_scd_year_sell_inco -- 预测次年销售收入
    ,other_chn_provi_oper_cap -- 其他渠道提供的营运资金
    ,advise_flg -- 通知展业标志
    ,mon_rent_lmt -- 月租金额
    ,corp_in_mons -- 企业入驻月份数
    ,score_val -- 评分分值
    ,obtain_emply_number -- 从业人数
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,indus_type_cd -- 行业类型代码
    ,crdtc_rest_cd -- 征信检验结果代码
    ,cust_mgr_id -- 客户经理编号
    ,belong_brch_org_id -- 所属分行机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206004'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 申请流水号
    ,P1.APPLYNO -- 信贷申请流水号
    ,P1.PRDCODE -- 产品编号
    ,P1.PRDNAME -- 产品名称
    ,P1.PRODUCTCHANNEL -- 产品简称
    ,P1.APPCHANNEL -- 接入渠道编号
    ,to_number(nvl(trim(P1.APPLYTERM),0)) -- 贷款期限
    ,P1.APPLYSUM -- 申请金额
    ,P1.FINALAPPLYAMOUNT -- 审批额度
    ,P1.INPUTDATE -- 审批申请日期
    ,P1.APPLYENDDATE -- 审批结束日期
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 审批状态代码
    ,nvl(trim(P1.STATUS),'-') -- 任务状态代码
    ,P1.CUSID -- 法人客户编号
    ,P1.ISSDATE -- 签发日期
    ,P1.EXPIRYDATE -- 借款人证件到期日期
    ,P1.DWELLPROVINCECODE -- 居住所在省份
    ,P1.DWELLCITYCODE -- 居住所在城市
    ,P1.DWELLAREACODE -- 居住所在区域
    ,P1.DWELLADDRESS -- 居住地址
    ,nvl(trim(P1.CAREER),'-') -- 职业代码
    ,P1.NATIONALITY -- 国籍代码
    ,P1.ENTNAME -- 企业名称
    ,${iml_schema}.dateformat_min(P1.REGISTERDATE) -- 企业注册日期
    ,P1.CREDITCODE -- 统一社会信用代码
    ,P1.TAXNO -- 纳税人识别号
    ,P1.TAXFLAG -- 税务查询标志
    ,P1.TAXAPPLYNO -- 税务查询授权流水号
    ,P1.PROCEEDS -- 经营收入
    ,P1.SCALE -- 企业规模代码
    ,P1.TATALASSET -- 资产合计
    ,P1.SYSID -- 数据来源代码
    ,nvl(trim(P1.QRYOPERTP),'-') -- 查询申请类型代码
    ,nvl(trim(P1.APPLYFLAG),'-') -- 授权标志
    ,nvl(trim(P1.AUTHOTYPE),'-') -- 授权方式代码
    ,nvl(trim(P1.BIOMETRICS),'-') -- 生物识别方式代码
    ,${iml_schema}.dateformat_max2(P1.AUTHOTIME) -- 授权日期
    ,P1.AUTHOSTRDATE -- 授权生效日期
    ,P1.AUTHOENDDATE -- 授权失效日期
    ,P1.WARNINGINFO -- 预警信息
    ,P1.FAILREASON -- 拒绝原因描述
    ,P1.BUSINESSSCOPE -- 经营范围
    ,${iml_schema}.dateformat_max2(P1.BUSINESSVALIDITY) -- 营业执照有效期
    ,P1.REGISTEREDADDRESS -- 注册地址
    ,nvl(trim(P1.ISSMALLENT),'-') -- 小微企业标志
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.NEXTYEARINCOME -- 预测次年销售收入
    ,P1.OTHERINCOME -- 其他渠道提供的营运资金
    ,nvl(trim(P1.INFORMFLAG),'-') -- 通知展业标志
    ,to_number(nvl(trim(P1.ENTMOUTHPRICE),0)) -- 月租金额
    ,to_number(nvl(trim(P1.ENTMOUTH),0)) -- 企业入驻月份数
    ,P1.AUTOSCORE -- 评分分值
    ,P1.EMPCOUNTYEAR -- 从业人数
    ,nvl(trim(P1.GONGANCHECKRESULT),'-') -- 联网核查结果代码
    ,nvl(trim(P1.TRADECODE),'-') -- 行业类型代码
    ,nvl(trim(P1.ZHENGXINCHECKRESULT),'-') -- 征信检验结果代码
    ,P1.INPUTID -- 客户经理编号
    ,P1.BELONGDEPT -- 所属分行机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_xked_iqp_loan_prior' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_xked_iqp_loan_prior p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_tm 
  	                                group by 
  	                                        appl_id
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
        into ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,prod_abbr -- 产品简称
    ,access_chn_id -- 接入渠道编号
    ,loan_tenor -- 贷款期限
    ,appl_amt -- 申请金额
    ,apv_lmt -- 审批额度
    ,apv_appl_dt -- 审批申请日期
    ,apv_end_dt -- 审批结束日期
    ,apv_status_cd -- 审批状态代码
    ,task_status_cd -- 任务状态代码
    ,lp_cust_id -- 法人客户编号
    ,issue_dt -- 签发日期
    ,brwer_cert_exp_dt -- 借款人证件到期日期
    ,resd_local_prov -- 居住所在省份
    ,resd_city -- 居住所在城市
    ,resd_local_rg -- 居住所在区域
    ,resdnt_addr -- 居住地址
    ,career_cd -- 职业代码
    ,nation_cd -- 国籍代码
    ,corp_name -- 企业名称
    ,corp_rgst_dt -- 企业注册日期
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,tax_num -- 纳税人识别号
    ,tax_que_flg -- 税务查询标志
    ,tax_que_auth_flow_num -- 税务查询授权流水号
    ,mang_inco -- 经营收入
    ,corp_size_cd -- 企业规模代码
    ,asset_sum -- 资产合计
    ,data_src_cd -- 数据来源代码
    ,que_appl_type_cd -- 查询申请类型代码
    ,auth_flg -- 授权标志
    ,auth_way_cd -- 授权方式代码
    ,biome_trics -- 生物识别方式代码
    ,auth_dt -- 授权日期
    ,auth_effect_dt -- 授权生效日期
    ,auth_invalid_dt -- 授权失效日期
    ,warn_info -- 预警信息
    ,refuse_rs_descb -- 拒绝原因描述
    ,mang_range -- 经营范围
    ,bus_lics_vp -- 营业执照有效期
    ,rgst_addr -- 注册地址
    ,sm_corp_flg -- 小微企业标志
    ,rgst_org_id -- 登记机构编号
    ,pre_scd_year_sell_inco -- 预测次年销售收入
    ,other_chn_provi_oper_cap -- 其他渠道提供的营运资金
    ,advise_flg -- 通知展业标志
    ,mon_rent_lmt -- 月租金额
    ,corp_in_mons -- 企业入驻月份数
    ,score_val -- 评分分值
    ,obtain_emply_number -- 从业人数
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,indus_type_cd -- 行业类型代码
    ,crdtc_rest_cd -- 征信检验结果代码
    ,cust_mgr_id -- 客户经理编号
    ,belong_brch_org_id -- 所属分行机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,prod_abbr -- 产品简称
    ,access_chn_id -- 接入渠道编号
    ,loan_tenor -- 贷款期限
    ,appl_amt -- 申请金额
    ,apv_lmt -- 审批额度
    ,apv_appl_dt -- 审批申请日期
    ,apv_end_dt -- 审批结束日期
    ,apv_status_cd -- 审批状态代码
    ,task_status_cd -- 任务状态代码
    ,lp_cust_id -- 法人客户编号
    ,issue_dt -- 签发日期
    ,brwer_cert_exp_dt -- 借款人证件到期日期
    ,resd_local_prov -- 居住所在省份
    ,resd_city -- 居住所在城市
    ,resd_local_rg -- 居住所在区域
    ,resdnt_addr -- 居住地址
    ,career_cd -- 职业代码
    ,nation_cd -- 国籍代码
    ,corp_name -- 企业名称
    ,corp_rgst_dt -- 企业注册日期
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,tax_num -- 纳税人识别号
    ,tax_que_flg -- 税务查询标志
    ,tax_que_auth_flow_num -- 税务查询授权流水号
    ,mang_inco -- 经营收入
    ,corp_size_cd -- 企业规模代码
    ,asset_sum -- 资产合计
    ,data_src_cd -- 数据来源代码
    ,que_appl_type_cd -- 查询申请类型代码
    ,auth_flg -- 授权标志
    ,auth_way_cd -- 授权方式代码
    ,biome_trics -- 生物识别方式代码
    ,auth_dt -- 授权日期
    ,auth_effect_dt -- 授权生效日期
    ,auth_invalid_dt -- 授权失效日期
    ,warn_info -- 预警信息
    ,refuse_rs_descb -- 拒绝原因描述
    ,mang_range -- 经营范围
    ,bus_lics_vp -- 营业执照有效期
    ,rgst_addr -- 注册地址
    ,sm_corp_flg -- 小微企业标志
    ,rgst_org_id -- 登记机构编号
    ,pre_scd_year_sell_inco -- 预测次年销售收入
    ,other_chn_provi_oper_cap -- 其他渠道提供的营运资金
    ,advise_flg -- 通知展业标志
    ,mon_rent_lmt -- 月租金额
    ,corp_in_mons -- 企业入驻月份数
    ,score_val -- 评分分值
    ,obtain_emply_number -- 从业人数
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,indus_type_cd -- 行业类型代码
    ,crdtc_rest_cd -- 征信检验结果代码
    ,cust_mgr_id -- 客户经理编号
    ,belong_brch_org_id -- 所属分行机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.appl_flow_num, o.appl_flow_num) as appl_flow_num -- 申请流水号
    ,nvl(n.crdt_appl_flow_num, o.crdt_appl_flow_num) as crdt_appl_flow_num -- 信贷申请流水号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.prod_abbr, o.prod_abbr) as prod_abbr -- 产品简称
    ,nvl(n.access_chn_id, o.access_chn_id) as access_chn_id -- 接入渠道编号
    ,nvl(n.loan_tenor, o.loan_tenor) as loan_tenor -- 贷款期限
    ,nvl(n.appl_amt, o.appl_amt) as appl_amt -- 申请金额
    ,nvl(n.apv_lmt, o.apv_lmt) as apv_lmt -- 审批额度
    ,nvl(n.apv_appl_dt, o.apv_appl_dt) as apv_appl_dt -- 审批申请日期
    ,nvl(n.apv_end_dt, o.apv_end_dt) as apv_end_dt -- 审批结束日期
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.task_status_cd, o.task_status_cd) as task_status_cd -- 任务状态代码
    ,nvl(n.lp_cust_id, o.lp_cust_id) as lp_cust_id -- 法人客户编号
    ,nvl(n.issue_dt, o.issue_dt) as issue_dt -- 签发日期
    ,nvl(n.brwer_cert_exp_dt, o.brwer_cert_exp_dt) as brwer_cert_exp_dt -- 借款人证件到期日期
    ,nvl(n.resd_local_prov, o.resd_local_prov) as resd_local_prov -- 居住所在省份
    ,nvl(n.resd_city, o.resd_city) as resd_city -- 居住所在城市
    ,nvl(n.resd_local_rg, o.resd_local_rg) as resd_local_rg -- 居住所在区域
    ,nvl(n.resdnt_addr, o.resdnt_addr) as resdnt_addr -- 居住地址
    ,nvl(n.career_cd, o.career_cd) as career_cd -- 职业代码
    ,nvl(n.nation_cd, o.nation_cd) as nation_cd -- 国籍代码
    ,nvl(n.corp_name, o.corp_name) as corp_name -- 企业名称
    ,nvl(n.corp_rgst_dt, o.corp_rgst_dt) as corp_rgst_dt -- 企业注册日期
    ,nvl(n.unify_soci_crdt_cd, o.unify_soci_crdt_cd) as unify_soci_crdt_cd -- 统一社会信用代码
    ,nvl(n.tax_num, o.tax_num) as tax_num -- 纳税人识别号
    ,nvl(n.tax_que_flg, o.tax_que_flg) as tax_que_flg -- 税务查询标志
    ,nvl(n.tax_que_auth_flow_num, o.tax_que_auth_flow_num) as tax_que_auth_flow_num -- 税务查询授权流水号
    ,nvl(n.mang_inco, o.mang_inco) as mang_inco -- 经营收入
    ,nvl(n.corp_size_cd, o.corp_size_cd) as corp_size_cd -- 企业规模代码
    ,nvl(n.asset_sum, o.asset_sum) as asset_sum -- 资产合计
    ,nvl(n.data_src_cd, o.data_src_cd) as data_src_cd -- 数据来源代码
    ,nvl(n.que_appl_type_cd, o.que_appl_type_cd) as que_appl_type_cd -- 查询申请类型代码
    ,nvl(n.auth_flg, o.auth_flg) as auth_flg -- 授权标志
    ,nvl(n.auth_way_cd, o.auth_way_cd) as auth_way_cd -- 授权方式代码
    ,nvl(n.biome_trics, o.biome_trics) as biome_trics -- 生物识别方式代码
    ,nvl(n.auth_dt, o.auth_dt) as auth_dt -- 授权日期
    ,nvl(n.auth_effect_dt, o.auth_effect_dt) as auth_effect_dt -- 授权生效日期
    ,nvl(n.auth_invalid_dt, o.auth_invalid_dt) as auth_invalid_dt -- 授权失效日期
    ,nvl(n.warn_info, o.warn_info) as warn_info -- 预警信息
    ,nvl(n.refuse_rs_descb, o.refuse_rs_descb) as refuse_rs_descb -- 拒绝原因描述
    ,nvl(n.mang_range, o.mang_range) as mang_range -- 经营范围
    ,nvl(n.bus_lics_vp, o.bus_lics_vp) as bus_lics_vp -- 营业执照有效期
    ,nvl(n.rgst_addr, o.rgst_addr) as rgst_addr -- 注册地址
    ,nvl(n.sm_corp_flg, o.sm_corp_flg) as sm_corp_flg -- 小微企业标志
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.pre_scd_year_sell_inco, o.pre_scd_year_sell_inco) as pre_scd_year_sell_inco -- 预测次年销售收入
    ,nvl(n.other_chn_provi_oper_cap, o.other_chn_provi_oper_cap) as other_chn_provi_oper_cap -- 其他渠道提供的营运资金
    ,nvl(n.advise_flg, o.advise_flg) as advise_flg -- 通知展业标志
    ,nvl(n.mon_rent_lmt, o.mon_rent_lmt) as mon_rent_lmt -- 月租金额
    ,nvl(n.corp_in_mons, o.corp_in_mons) as corp_in_mons -- 企业入驻月份数
    ,nvl(n.score_val, o.score_val) as score_val -- 评分分值
    ,nvl(n.obtain_emply_number, o.obtain_emply_number) as obtain_emply_number -- 从业人数
    ,nvl(n.netw_vrfction_rest_cd, o.netw_vrfction_rest_cd) as netw_vrfction_rest_cd -- 联网核查结果代码
    ,nvl(n.indus_type_cd, o.indus_type_cd) as indus_type_cd -- 行业类型代码
    ,nvl(n.crdtc_rest_cd, o.crdtc_rest_cd) as crdtc_rest_cd -- 征信检验结果代码
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.belong_brch_org_id, o.belong_brch_org_id) as belong_brch_org_id -- 所属分行机构编号
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
where (
        o.appl_id is null
        and o.lp_id is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
    )
    or (
        o.appl_flow_num <> n.appl_flow_num
        or o.crdt_appl_flow_num <> n.crdt_appl_flow_num
        or o.prod_id <> n.prod_id
        or o.prod_name <> n.prod_name
        or o.prod_abbr <> n.prod_abbr
        or o.access_chn_id <> n.access_chn_id
        or o.loan_tenor <> n.loan_tenor
        or o.appl_amt <> n.appl_amt
        or o.apv_lmt <> n.apv_lmt
        or o.apv_appl_dt <> n.apv_appl_dt
        or o.apv_end_dt <> n.apv_end_dt
        or o.apv_status_cd <> n.apv_status_cd
        or o.task_status_cd <> n.task_status_cd
        or o.lp_cust_id <> n.lp_cust_id
        or o.issue_dt <> n.issue_dt
        or o.brwer_cert_exp_dt <> n.brwer_cert_exp_dt
        or o.resd_local_prov <> n.resd_local_prov
        or o.resd_city <> n.resd_city
        or o.resd_local_rg <> n.resd_local_rg
        or o.resdnt_addr <> n.resdnt_addr
        or o.career_cd <> n.career_cd
        or o.nation_cd <> n.nation_cd
        or o.corp_name <> n.corp_name
        or o.corp_rgst_dt <> n.corp_rgst_dt
        or o.unify_soci_crdt_cd <> n.unify_soci_crdt_cd
        or o.tax_num <> n.tax_num
        or o.tax_que_flg <> n.tax_que_flg
        or o.tax_que_auth_flow_num <> n.tax_que_auth_flow_num
        or o.mang_inco <> n.mang_inco
        or o.corp_size_cd <> n.corp_size_cd
        or o.asset_sum <> n.asset_sum
        or o.data_src_cd <> n.data_src_cd
        or o.que_appl_type_cd <> n.que_appl_type_cd
        or o.auth_flg <> n.auth_flg
        or o.auth_way_cd <> n.auth_way_cd
        or o.biome_trics <> n.biome_trics
        or o.auth_dt <> n.auth_dt
        or o.auth_effect_dt <> n.auth_effect_dt
        or o.auth_invalid_dt <> n.auth_invalid_dt
        or o.warn_info <> n.warn_info
        or o.refuse_rs_descb <> n.refuse_rs_descb
        or o.mang_range <> n.mang_range
        or o.bus_lics_vp <> n.bus_lics_vp
        or o.rgst_addr <> n.rgst_addr
        or o.sm_corp_flg <> n.sm_corp_flg
        or o.rgst_org_id <> n.rgst_org_id
        or o.pre_scd_year_sell_inco <> n.pre_scd_year_sell_inco
        or o.other_chn_provi_oper_cap <> n.other_chn_provi_oper_cap
        or o.advise_flg <> n.advise_flg
        or o.mon_rent_lmt <> n.mon_rent_lmt
        or o.corp_in_mons <> n.corp_in_mons
        or o.score_val <> n.score_val
        or o.obtain_emply_number <> n.obtain_emply_number
        or o.netw_vrfction_rest_cd <> n.netw_vrfction_rest_cd
        or o.indus_type_cd <> n.indus_type_cd
        or o.crdtc_rest_cd <> n.crdtc_rest_cd
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.belong_brch_org_id <> n.belong_brch_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,prod_abbr -- 产品简称
    ,access_chn_id -- 接入渠道编号
    ,loan_tenor -- 贷款期限
    ,appl_amt -- 申请金额
    ,apv_lmt -- 审批额度
    ,apv_appl_dt -- 审批申请日期
    ,apv_end_dt -- 审批结束日期
    ,apv_status_cd -- 审批状态代码
    ,task_status_cd -- 任务状态代码
    ,lp_cust_id -- 法人客户编号
    ,issue_dt -- 签发日期
    ,brwer_cert_exp_dt -- 借款人证件到期日期
    ,resd_local_prov -- 居住所在省份
    ,resd_city -- 居住所在城市
    ,resd_local_rg -- 居住所在区域
    ,resdnt_addr -- 居住地址
    ,career_cd -- 职业代码
    ,nation_cd -- 国籍代码
    ,corp_name -- 企业名称
    ,corp_rgst_dt -- 企业注册日期
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,tax_num -- 纳税人识别号
    ,tax_que_flg -- 税务查询标志
    ,tax_que_auth_flow_num -- 税务查询授权流水号
    ,mang_inco -- 经营收入
    ,corp_size_cd -- 企业规模代码
    ,asset_sum -- 资产合计
    ,data_src_cd -- 数据来源代码
    ,que_appl_type_cd -- 查询申请类型代码
    ,auth_flg -- 授权标志
    ,auth_way_cd -- 授权方式代码
    ,biome_trics -- 生物识别方式代码
    ,auth_dt -- 授权日期
    ,auth_effect_dt -- 授权生效日期
    ,auth_invalid_dt -- 授权失效日期
    ,warn_info -- 预警信息
    ,refuse_rs_descb -- 拒绝原因描述
    ,mang_range -- 经营范围
    ,bus_lics_vp -- 营业执照有效期
    ,rgst_addr -- 注册地址
    ,sm_corp_flg -- 小微企业标志
    ,rgst_org_id -- 登记机构编号
    ,pre_scd_year_sell_inco -- 预测次年销售收入
    ,other_chn_provi_oper_cap -- 其他渠道提供的营运资金
    ,advise_flg -- 通知展业标志
    ,mon_rent_lmt -- 月租金额
    ,corp_in_mons -- 企业入驻月份数
    ,score_val -- 评分分值
    ,obtain_emply_number -- 从业人数
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,indus_type_cd -- 行业类型代码
    ,crdtc_rest_cd -- 征信检验结果代码
    ,cust_mgr_id -- 客户经理编号
    ,belong_brch_org_id -- 所属分行机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,prod_abbr -- 产品简称
    ,access_chn_id -- 接入渠道编号
    ,loan_tenor -- 贷款期限
    ,appl_amt -- 申请金额
    ,apv_lmt -- 审批额度
    ,apv_appl_dt -- 审批申请日期
    ,apv_end_dt -- 审批结束日期
    ,apv_status_cd -- 审批状态代码
    ,task_status_cd -- 任务状态代码
    ,lp_cust_id -- 法人客户编号
    ,issue_dt -- 签发日期
    ,brwer_cert_exp_dt -- 借款人证件到期日期
    ,resd_local_prov -- 居住所在省份
    ,resd_city -- 居住所在城市
    ,resd_local_rg -- 居住所在区域
    ,resdnt_addr -- 居住地址
    ,career_cd -- 职业代码
    ,nation_cd -- 国籍代码
    ,corp_name -- 企业名称
    ,corp_rgst_dt -- 企业注册日期
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,tax_num -- 纳税人识别号
    ,tax_que_flg -- 税务查询标志
    ,tax_que_auth_flow_num -- 税务查询授权流水号
    ,mang_inco -- 经营收入
    ,corp_size_cd -- 企业规模代码
    ,asset_sum -- 资产合计
    ,data_src_cd -- 数据来源代码
    ,que_appl_type_cd -- 查询申请类型代码
    ,auth_flg -- 授权标志
    ,auth_way_cd -- 授权方式代码
    ,biome_trics -- 生物识别方式代码
    ,auth_dt -- 授权日期
    ,auth_effect_dt -- 授权生效日期
    ,auth_invalid_dt -- 授权失效日期
    ,warn_info -- 预警信息
    ,refuse_rs_descb -- 拒绝原因描述
    ,mang_range -- 经营范围
    ,bus_lics_vp -- 营业执照有效期
    ,rgst_addr -- 注册地址
    ,sm_corp_flg -- 小微企业标志
    ,rgst_org_id -- 登记机构编号
    ,pre_scd_year_sell_inco -- 预测次年销售收入
    ,other_chn_provi_oper_cap -- 其他渠道提供的营运资金
    ,advise_flg -- 通知展业标志
    ,mon_rent_lmt -- 月租金额
    ,corp_in_mons -- 企业入驻月份数
    ,score_val -- 评分分值
    ,obtain_emply_number -- 从业人数
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,indus_type_cd -- 行业类型代码
    ,crdtc_rest_cd -- 征信检验结果代码
    ,cust_mgr_id -- 客户经理编号
    ,belong_brch_org_id -- 所属分行机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appl_id -- 申请编号
    ,o.lp_id -- 法人编号
    ,o.appl_flow_num -- 申请流水号
    ,o.crdt_appl_flow_num -- 信贷申请流水号
    ,o.prod_id -- 产品编号
    ,o.prod_name -- 产品名称
    ,o.prod_abbr -- 产品简称
    ,o.access_chn_id -- 接入渠道编号
    ,o.loan_tenor -- 贷款期限
    ,o.appl_amt -- 申请金额
    ,o.apv_lmt -- 审批额度
    ,o.apv_appl_dt -- 审批申请日期
    ,o.apv_end_dt -- 审批结束日期
    ,o.apv_status_cd -- 审批状态代码
    ,o.task_status_cd -- 任务状态代码
    ,o.lp_cust_id -- 法人客户编号
    ,o.issue_dt -- 签发日期
    ,o.brwer_cert_exp_dt -- 借款人证件到期日期
    ,o.resd_local_prov -- 居住所在省份
    ,o.resd_city -- 居住所在城市
    ,o.resd_local_rg -- 居住所在区域
    ,o.resdnt_addr -- 居住地址
    ,o.career_cd -- 职业代码
    ,o.nation_cd -- 国籍代码
    ,o.corp_name -- 企业名称
    ,o.corp_rgst_dt -- 企业注册日期
    ,o.unify_soci_crdt_cd -- 统一社会信用代码
    ,o.tax_num -- 纳税人识别号
    ,o.tax_que_flg -- 税务查询标志
    ,o.tax_que_auth_flow_num -- 税务查询授权流水号
    ,o.mang_inco -- 经营收入
    ,o.corp_size_cd -- 企业规模代码
    ,o.asset_sum -- 资产合计
    ,o.data_src_cd -- 数据来源代码
    ,o.que_appl_type_cd -- 查询申请类型代码
    ,o.auth_flg -- 授权标志
    ,o.auth_way_cd -- 授权方式代码
    ,o.biome_trics -- 生物识别方式代码
    ,o.auth_dt -- 授权日期
    ,o.auth_effect_dt -- 授权生效日期
    ,o.auth_invalid_dt -- 授权失效日期
    ,o.warn_info -- 预警信息
    ,o.refuse_rs_descb -- 拒绝原因描述
    ,o.mang_range -- 经营范围
    ,o.bus_lics_vp -- 营业执照有效期
    ,o.rgst_addr -- 注册地址
    ,o.sm_corp_flg -- 小微企业标志
    ,o.rgst_org_id -- 登记机构编号
    ,o.pre_scd_year_sell_inco -- 预测次年销售收入
    ,o.other_chn_provi_oper_cap -- 其他渠道提供的营运资金
    ,o.advise_flg -- 通知展业标志
    ,o.mon_rent_lmt -- 月租金额
    ,o.corp_in_mons -- 企业入驻月份数
    ,o.score_val -- 评分分值
    ,o.obtain_emply_number -- 从业人数
    ,o.netw_vrfction_rest_cd -- 联网核查结果代码
    ,o.indus_type_cd -- 行业类型代码
    ,o.crdtc_rest_cd -- 征信检验结果代码
    ,o.cust_mgr_id -- 客户经理编号
    ,o.belong_brch_org_id -- 所属分行机构编号
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
from ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_bk o
    left join ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_xked_pre_loan_appl_info;
--alter table ${iml_schema}.agt_xked_pre_loan_appl_info truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_xked_pre_loan_appl_info') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_xked_pre_loan_appl_info drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_xked_pre_loan_appl_info modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_xked_pre_loan_appl_info exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_cl;
alter table ${iml_schema}.agt_xked_pre_loan_appl_info exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_xked_pre_loan_appl_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_tm purge;
drop table ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_op purge;
drop table ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_xked_pre_loan_appl_info_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_xked_pre_loan_appl_info', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
