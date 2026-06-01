/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t01_per_cust_ext_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.eifs_t01_per_cust_ext_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t01_per_cust_ext_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t01_per_cust_ext_info_op purge;
drop table ${iol_schema}.eifs_t01_per_cust_ext_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_per_cust_ext_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t01_per_cust_ext_info where 0=1;

create table ${iol_schema}.eifs_t01_per_cust_ext_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t01_per_cust_ext_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t01_per_cust_ext_info_cl(
            party_id -- 参与人id
            ,cust_card_level_cd -- 客户持卡等级
            ,cust_asset_level_cd -- 客户资产等级
            ,cust_risk_level_cd -- 风险等级
            ,bad_rec_reason -- 不良记录原因
            ,credit_limit_flag_cd -- 综合授信额度
            ,used_crdt_limit -- 已用授信额度
            ,avail_crdt_limit -- 可用授信额度
            ,loan_card_num -- 贷款卡号
            ,resdnt_char_cd -- 居民性质
            ,resdnt_situ_cd -- 居住状况
            ,socl_card_no -- 社保卡卡号
            ,fund_acct_no -- 公积金账号
            ,hght -- 身高
            ,wght -- 体重
            ,mon_in -- 月收入
            ,year_in -- 年收入
            ,family_mon_in -- 家庭月收入
            ,family_in -- 家庭年收入
            ,salary_acc_num -- 工资帐号
            ,salary_acc_num_bank -- 工资帐号开户银行
            ,interests -- 兴趣爱好
            ,blood_type_cd -- 血型
            ,security_grade -- 客户安全等级
            ,is_indiv_merchant -- 是否为个体工商户
            ,indiv_busi_type -- 个体工商户证件类型
            ,indiv_busi_license -- 个体工商户证件号码
            ,is_small_micro_ent -- 是否为小微企业主
            ,small_micro_ent_type -- 小微企业主证件类型
            ,small_micro_ent_license -- 小微企业主证件号码
            ,marketing_num -- 营销活动编号
            ,int_crdt_rating_cd -- 内部信用评级
            ,loan_card_num_status -- 贷款卡号状态
            ,graduate_school -- 毕业院校
            ,card_type -- 开卡类型
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,tax_year_in -- 纳税人年收入
            ,cust_risk_level -- 客户风评等级
            ,risk_validity_period -- 风评有效期
            ,risk_assessment_completed -- 是否已完成临柜风评
            ,risk_assessment_version -- 风评问卷版本号
            ,risk_estim_score -- 风评评估得分
            ,risk_update_ts -- 风评更新时间
            ,risk_update_te -- 风评更新渠道
            ,send_marketing_sms_flag -- 是否同意发送营销信息短信
            ,elig_inve_cert_flg -- 合格投资者认证标志
            ,elig_inve_validper -- 合格投资者有限期
            ,elig_inve_src_chn -- 合格投资者来源渠道
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,revenue_currency -- 收入币种
            ,belong_indus_cd -- 所属行业类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t01_per_cust_ext_info_op(
            party_id -- 参与人id
            ,cust_card_level_cd -- 客户持卡等级
            ,cust_asset_level_cd -- 客户资产等级
            ,cust_risk_level_cd -- 风险等级
            ,bad_rec_reason -- 不良记录原因
            ,credit_limit_flag_cd -- 综合授信额度
            ,used_crdt_limit -- 已用授信额度
            ,avail_crdt_limit -- 可用授信额度
            ,loan_card_num -- 贷款卡号
            ,resdnt_char_cd -- 居民性质
            ,resdnt_situ_cd -- 居住状况
            ,socl_card_no -- 社保卡卡号
            ,fund_acct_no -- 公积金账号
            ,hght -- 身高
            ,wght -- 体重
            ,mon_in -- 月收入
            ,year_in -- 年收入
            ,family_mon_in -- 家庭月收入
            ,family_in -- 家庭年收入
            ,salary_acc_num -- 工资帐号
            ,salary_acc_num_bank -- 工资帐号开户银行
            ,interests -- 兴趣爱好
            ,blood_type_cd -- 血型
            ,security_grade -- 客户安全等级
            ,is_indiv_merchant -- 是否为个体工商户
            ,indiv_busi_type -- 个体工商户证件类型
            ,indiv_busi_license -- 个体工商户证件号码
            ,is_small_micro_ent -- 是否为小微企业主
            ,small_micro_ent_type -- 小微企业主证件类型
            ,small_micro_ent_license -- 小微企业主证件号码
            ,marketing_num -- 营销活动编号
            ,int_crdt_rating_cd -- 内部信用评级
            ,loan_card_num_status -- 贷款卡号状态
            ,graduate_school -- 毕业院校
            ,card_type -- 开卡类型
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,tax_year_in -- 纳税人年收入
            ,cust_risk_level -- 客户风评等级
            ,risk_validity_period -- 风评有效期
            ,risk_assessment_completed -- 是否已完成临柜风评
            ,risk_assessment_version -- 风评问卷版本号
            ,risk_estim_score -- 风评评估得分
            ,risk_update_ts -- 风评更新时间
            ,risk_update_te -- 风评更新渠道
            ,send_marketing_sms_flag -- 是否同意发送营销信息短信
            ,elig_inve_cert_flg -- 合格投资者认证标志
            ,elig_inve_validper -- 合格投资者有限期
            ,elig_inve_src_chn -- 合格投资者来源渠道
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,revenue_currency -- 收入币种
            ,belong_indus_cd -- 所属行业类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 参与人id
    ,nvl(n.cust_card_level_cd, o.cust_card_level_cd) as cust_card_level_cd -- 客户持卡等级
    ,nvl(n.cust_asset_level_cd, o.cust_asset_level_cd) as cust_asset_level_cd -- 客户资产等级
    ,nvl(n.cust_risk_level_cd, o.cust_risk_level_cd) as cust_risk_level_cd -- 风险等级
    ,nvl(n.bad_rec_reason, o.bad_rec_reason) as bad_rec_reason -- 不良记录原因
    ,nvl(n.credit_limit_flag_cd, o.credit_limit_flag_cd) as credit_limit_flag_cd -- 综合授信额度
    ,nvl(n.used_crdt_limit, o.used_crdt_limit) as used_crdt_limit -- 已用授信额度
    ,nvl(n.avail_crdt_limit, o.avail_crdt_limit) as avail_crdt_limit -- 可用授信额度
    ,nvl(n.loan_card_num, o.loan_card_num) as loan_card_num -- 贷款卡号
    ,nvl(n.resdnt_char_cd, o.resdnt_char_cd) as resdnt_char_cd -- 居民性质
    ,nvl(n.resdnt_situ_cd, o.resdnt_situ_cd) as resdnt_situ_cd -- 居住状况
    ,nvl(n.socl_card_no, o.socl_card_no) as socl_card_no -- 社保卡卡号
    ,nvl(n.fund_acct_no, o.fund_acct_no) as fund_acct_no -- 公积金账号
    ,nvl(n.hght, o.hght) as hght -- 身高
    ,nvl(n.wght, o.wght) as wght -- 体重
    ,nvl(n.mon_in, o.mon_in) as mon_in -- 月收入
    ,nvl(n.year_in, o.year_in) as year_in -- 年收入
    ,nvl(n.family_mon_in, o.family_mon_in) as family_mon_in -- 家庭月收入
    ,nvl(n.family_in, o.family_in) as family_in -- 家庭年收入
    ,nvl(n.salary_acc_num, o.salary_acc_num) as salary_acc_num -- 工资帐号
    ,nvl(n.salary_acc_num_bank, o.salary_acc_num_bank) as salary_acc_num_bank -- 工资帐号开户银行
    ,nvl(n.interests, o.interests) as interests -- 兴趣爱好
    ,nvl(n.blood_type_cd, o.blood_type_cd) as blood_type_cd -- 血型
    ,nvl(n.security_grade, o.security_grade) as security_grade -- 客户安全等级
    ,nvl(n.is_indiv_merchant, o.is_indiv_merchant) as is_indiv_merchant -- 是否为个体工商户
    ,nvl(n.indiv_busi_type, o.indiv_busi_type) as indiv_busi_type -- 个体工商户证件类型
    ,nvl(n.indiv_busi_license, o.indiv_busi_license) as indiv_busi_license -- 个体工商户证件号码
    ,nvl(n.is_small_micro_ent, o.is_small_micro_ent) as is_small_micro_ent -- 是否为小微企业主
    ,nvl(n.small_micro_ent_type, o.small_micro_ent_type) as small_micro_ent_type -- 小微企业主证件类型
    ,nvl(n.small_micro_ent_license, o.small_micro_ent_license) as small_micro_ent_license -- 小微企业主证件号码
    ,nvl(n.marketing_num, o.marketing_num) as marketing_num -- 营销活动编号
    ,nvl(n.int_crdt_rating_cd, o.int_crdt_rating_cd) as int_crdt_rating_cd -- 内部信用评级
    ,nvl(n.loan_card_num_status, o.loan_card_num_status) as loan_card_num_status -- 贷款卡号状态
    ,nvl(n.graduate_school, o.graduate_school) as graduate_school -- 毕业院校
    ,nvl(n.card_type, o.card_type) as card_type -- 开卡类型
    ,nvl(n.create_te, o.create_te) as create_te -- 创建柜员
    ,nvl(n.create_org, o.create_org) as create_org -- 创建机构号
    ,nvl(n.init_system_id, o.init_system_id) as init_system_id -- 创建渠道
    ,nvl(n.init_created_ts, o.init_created_ts) as init_created_ts -- 源系统创建时间
    ,nvl(n.created_ts, o.created_ts) as created_ts -- 进入ecif的时间
    ,nvl(n.updated_ts, o.updated_ts) as updated_ts -- 在ecif中失效的时间
    ,nvl(n.last_updated_te, o.last_updated_te) as last_updated_te -- 最新更新柜员
    ,nvl(n.last_updated_org, o.last_updated_org) as last_updated_org -- 最新更新机构号
    ,nvl(n.last_system_id, o.last_system_id) as last_system_id -- 最新更新渠道
    ,nvl(n.last_updated_ts, o.last_updated_ts) as last_updated_ts -- 最新更新时间
    ,nvl(n.tax_year_in, o.tax_year_in) as tax_year_in -- 纳税人年收入
    ,nvl(n.cust_risk_level, o.cust_risk_level) as cust_risk_level -- 客户风评等级
    ,nvl(n.risk_validity_period, o.risk_validity_period) as risk_validity_period -- 风评有效期
    ,nvl(n.risk_assessment_completed, o.risk_assessment_completed) as risk_assessment_completed -- 是否已完成临柜风评
    ,nvl(n.risk_assessment_version, o.risk_assessment_version) as risk_assessment_version -- 风评问卷版本号
    ,nvl(n.risk_estim_score, o.risk_estim_score) as risk_estim_score -- 风评评估得分
    ,nvl(n.risk_update_ts, o.risk_update_ts) as risk_update_ts -- 风评更新时间
    ,nvl(n.risk_update_te, o.risk_update_te) as risk_update_te -- 风评更新渠道
    ,nvl(n.send_marketing_sms_flag, o.send_marketing_sms_flag) as send_marketing_sms_flag -- 是否同意发送营销信息短信
    ,nvl(n.elig_inve_cert_flg, o.elig_inve_cert_flg) as elig_inve_cert_flg -- 合格投资者认证标志
    ,nvl(n.elig_inve_validper, o.elig_inve_validper) as elig_inve_validper -- 合格投资者有限期
    ,nvl(n.elig_inve_src_chn, o.elig_inve_src_chn) as elig_inve_src_chn -- 合格投资者来源渠道
    ,nvl(n.src_sys_num, o.src_sys_num) as src_sys_num -- 来源系统编号
    ,nvl(n.last_updated_src_sys_num, o.last_updated_src_sys_num) as last_updated_src_sys_num -- 最新更新源系统编号
    ,nvl(n.revenue_currency, o.revenue_currency) as revenue_currency -- 收入币种
    ,nvl(n.belong_indus_cd, o.belong_indus_cd) as belong_indus_cd -- 所属行业类型
    ,case when
            n.party_id is null
            and n.updated_ts is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.updated_ts is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.updated_ts is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.eifs_t01_per_cust_ext_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t01_per_cust_ext_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.party_id = n.party_id
            and o.updated_ts = n.updated_ts
where (
        o.party_id is null
        and o.updated_ts is null
    )
    or (
        n.party_id is null
        and n.updated_ts is null
    )
    or (
        o.cust_card_level_cd <> n.cust_card_level_cd
        or o.cust_asset_level_cd <> n.cust_asset_level_cd
        or o.cust_risk_level_cd <> n.cust_risk_level_cd
        or o.bad_rec_reason <> n.bad_rec_reason
        or o.credit_limit_flag_cd <> n.credit_limit_flag_cd
        or o.used_crdt_limit <> n.used_crdt_limit
        or o.avail_crdt_limit <> n.avail_crdt_limit
        or o.loan_card_num <> n.loan_card_num
        or o.resdnt_char_cd <> n.resdnt_char_cd
        or o.resdnt_situ_cd <> n.resdnt_situ_cd
        or o.socl_card_no <> n.socl_card_no
        or o.fund_acct_no <> n.fund_acct_no
        or o.hght <> n.hght
        or o.wght <> n.wght
        or o.mon_in <> n.mon_in
        or o.year_in <> n.year_in
        or o.family_mon_in <> n.family_mon_in
        or o.family_in <> n.family_in
        or o.salary_acc_num <> n.salary_acc_num
        or o.salary_acc_num_bank <> n.salary_acc_num_bank
        or o.interests <> n.interests
        or o.blood_type_cd <> n.blood_type_cd
        or o.security_grade <> n.security_grade
        or o.is_indiv_merchant <> n.is_indiv_merchant
        or o.indiv_busi_type <> n.indiv_busi_type
        or o.indiv_busi_license <> n.indiv_busi_license
        or o.is_small_micro_ent <> n.is_small_micro_ent
        or o.small_micro_ent_type <> n.small_micro_ent_type
        or o.small_micro_ent_license <> n.small_micro_ent_license
        or o.marketing_num <> n.marketing_num
        or o.int_crdt_rating_cd <> n.int_crdt_rating_cd
        or o.loan_card_num_status <> n.loan_card_num_status
        or o.graduate_school <> n.graduate_school
        or o.card_type <> n.card_type
        or o.create_te <> n.create_te
        or o.create_org <> n.create_org
        or o.init_system_id <> n.init_system_id
        or o.init_created_ts <> n.init_created_ts
        or o.created_ts <> n.created_ts
        or o.last_updated_te <> n.last_updated_te
        or o.last_updated_org <> n.last_updated_org
        or o.last_system_id <> n.last_system_id
        or o.last_updated_ts <> n.last_updated_ts
        or o.tax_year_in <> n.tax_year_in
        or o.cust_risk_level <> n.cust_risk_level
        or o.risk_validity_period <> n.risk_validity_period
        or o.risk_assessment_completed <> n.risk_assessment_completed
        or o.risk_assessment_version <> n.risk_assessment_version
        or o.risk_estim_score <> n.risk_estim_score
        or o.risk_update_ts <> n.risk_update_ts
        or o.risk_update_te <> n.risk_update_te
        or o.send_marketing_sms_flag <> n.send_marketing_sms_flag
        or o.elig_inve_cert_flg <> n.elig_inve_cert_flg
        or o.elig_inve_validper <> n.elig_inve_validper
        or o.elig_inve_src_chn <> n.elig_inve_src_chn
        or o.src_sys_num <> n.src_sys_num
        or o.last_updated_src_sys_num <> n.last_updated_src_sys_num
        or o.revenue_currency <> n.revenue_currency
        or o.belong_indus_cd <> n.belong_indus_cd
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t01_per_cust_ext_info_cl(
            party_id -- 参与人id
            ,cust_card_level_cd -- 客户持卡等级
            ,cust_asset_level_cd -- 客户资产等级
            ,cust_risk_level_cd -- 风险等级
            ,bad_rec_reason -- 不良记录原因
            ,credit_limit_flag_cd -- 综合授信额度
            ,used_crdt_limit -- 已用授信额度
            ,avail_crdt_limit -- 可用授信额度
            ,loan_card_num -- 贷款卡号
            ,resdnt_char_cd -- 居民性质
            ,resdnt_situ_cd -- 居住状况
            ,socl_card_no -- 社保卡卡号
            ,fund_acct_no -- 公积金账号
            ,hght -- 身高
            ,wght -- 体重
            ,mon_in -- 月收入
            ,year_in -- 年收入
            ,family_mon_in -- 家庭月收入
            ,family_in -- 家庭年收入
            ,salary_acc_num -- 工资帐号
            ,salary_acc_num_bank -- 工资帐号开户银行
            ,interests -- 兴趣爱好
            ,blood_type_cd -- 血型
            ,security_grade -- 客户安全等级
            ,is_indiv_merchant -- 是否为个体工商户
            ,indiv_busi_type -- 个体工商户证件类型
            ,indiv_busi_license -- 个体工商户证件号码
            ,is_small_micro_ent -- 是否为小微企业主
            ,small_micro_ent_type -- 小微企业主证件类型
            ,small_micro_ent_license -- 小微企业主证件号码
            ,marketing_num -- 营销活动编号
            ,int_crdt_rating_cd -- 内部信用评级
            ,loan_card_num_status -- 贷款卡号状态
            ,graduate_school -- 毕业院校
            ,card_type -- 开卡类型
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,tax_year_in -- 纳税人年收入
            ,cust_risk_level -- 客户风评等级
            ,risk_validity_period -- 风评有效期
            ,risk_assessment_completed -- 是否已完成临柜风评
            ,risk_assessment_version -- 风评问卷版本号
            ,risk_estim_score -- 风评评估得分
            ,risk_update_ts -- 风评更新时间
            ,risk_update_te -- 风评更新渠道
            ,send_marketing_sms_flag -- 是否同意发送营销信息短信
            ,elig_inve_cert_flg -- 合格投资者认证标志
            ,elig_inve_validper -- 合格投资者有限期
            ,elig_inve_src_chn -- 合格投资者来源渠道
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,revenue_currency -- 收入币种
            ,belong_indus_cd -- 所属行业类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t01_per_cust_ext_info_op(
            party_id -- 参与人id
            ,cust_card_level_cd -- 客户持卡等级
            ,cust_asset_level_cd -- 客户资产等级
            ,cust_risk_level_cd -- 风险等级
            ,bad_rec_reason -- 不良记录原因
            ,credit_limit_flag_cd -- 综合授信额度
            ,used_crdt_limit -- 已用授信额度
            ,avail_crdt_limit -- 可用授信额度
            ,loan_card_num -- 贷款卡号
            ,resdnt_char_cd -- 居民性质
            ,resdnt_situ_cd -- 居住状况
            ,socl_card_no -- 社保卡卡号
            ,fund_acct_no -- 公积金账号
            ,hght -- 身高
            ,wght -- 体重
            ,mon_in -- 月收入
            ,year_in -- 年收入
            ,family_mon_in -- 家庭月收入
            ,family_in -- 家庭年收入
            ,salary_acc_num -- 工资帐号
            ,salary_acc_num_bank -- 工资帐号开户银行
            ,interests -- 兴趣爱好
            ,blood_type_cd -- 血型
            ,security_grade -- 客户安全等级
            ,is_indiv_merchant -- 是否为个体工商户
            ,indiv_busi_type -- 个体工商户证件类型
            ,indiv_busi_license -- 个体工商户证件号码
            ,is_small_micro_ent -- 是否为小微企业主
            ,small_micro_ent_type -- 小微企业主证件类型
            ,small_micro_ent_license -- 小微企业主证件号码
            ,marketing_num -- 营销活动编号
            ,int_crdt_rating_cd -- 内部信用评级
            ,loan_card_num_status -- 贷款卡号状态
            ,graduate_school -- 毕业院校
            ,card_type -- 开卡类型
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,tax_year_in -- 纳税人年收入
            ,cust_risk_level -- 客户风评等级
            ,risk_validity_period -- 风评有效期
            ,risk_assessment_completed -- 是否已完成临柜风评
            ,risk_assessment_version -- 风评问卷版本号
            ,risk_estim_score -- 风评评估得分
            ,risk_update_ts -- 风评更新时间
            ,risk_update_te -- 风评更新渠道
            ,send_marketing_sms_flag -- 是否同意发送营销信息短信
            ,elig_inve_cert_flg -- 合格投资者认证标志
            ,elig_inve_validper -- 合格投资者有限期
            ,elig_inve_src_chn -- 合格投资者来源渠道
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,revenue_currency -- 收入币种
            ,belong_indus_cd -- 所属行业类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 参与人id
    ,o.cust_card_level_cd -- 客户持卡等级
    ,o.cust_asset_level_cd -- 客户资产等级
    ,o.cust_risk_level_cd -- 风险等级
    ,o.bad_rec_reason -- 不良记录原因
    ,o.credit_limit_flag_cd -- 综合授信额度
    ,o.used_crdt_limit -- 已用授信额度
    ,o.avail_crdt_limit -- 可用授信额度
    ,o.loan_card_num -- 贷款卡号
    ,o.resdnt_char_cd -- 居民性质
    ,o.resdnt_situ_cd -- 居住状况
    ,o.socl_card_no -- 社保卡卡号
    ,o.fund_acct_no -- 公积金账号
    ,o.hght -- 身高
    ,o.wght -- 体重
    ,o.mon_in -- 月收入
    ,o.year_in -- 年收入
    ,o.family_mon_in -- 家庭月收入
    ,o.family_in -- 家庭年收入
    ,o.salary_acc_num -- 工资帐号
    ,o.salary_acc_num_bank -- 工资帐号开户银行
    ,o.interests -- 兴趣爱好
    ,o.blood_type_cd -- 血型
    ,o.security_grade -- 客户安全等级
    ,o.is_indiv_merchant -- 是否为个体工商户
    ,o.indiv_busi_type -- 个体工商户证件类型
    ,o.indiv_busi_license -- 个体工商户证件号码
    ,o.is_small_micro_ent -- 是否为小微企业主
    ,o.small_micro_ent_type -- 小微企业主证件类型
    ,o.small_micro_ent_license -- 小微企业主证件号码
    ,o.marketing_num -- 营销活动编号
    ,o.int_crdt_rating_cd -- 内部信用评级
    ,o.loan_card_num_status -- 贷款卡号状态
    ,o.graduate_school -- 毕业院校
    ,o.card_type -- 开卡类型
    ,o.create_te -- 创建柜员
    ,o.create_org -- 创建机构号
    ,o.init_system_id -- 创建渠道
    ,o.init_created_ts -- 源系统创建时间
    ,o.created_ts -- 进入ecif的时间
    ,o.updated_ts -- 在ecif中失效的时间
    ,o.last_updated_te -- 最新更新柜员
    ,o.last_updated_org -- 最新更新机构号
    ,o.last_system_id -- 最新更新渠道
    ,o.last_updated_ts -- 最新更新时间
    ,o.tax_year_in -- 纳税人年收入
    ,o.cust_risk_level -- 客户风评等级
    ,o.risk_validity_period -- 风评有效期
    ,o.risk_assessment_completed -- 是否已完成临柜风评
    ,o.risk_assessment_version -- 风评问卷版本号
    ,o.risk_estim_score -- 风评评估得分
    ,o.risk_update_ts -- 风评更新时间
    ,o.risk_update_te -- 风评更新渠道
    ,o.send_marketing_sms_flag -- 是否同意发送营销信息短信
    ,o.elig_inve_cert_flg -- 合格投资者认证标志
    ,o.elig_inve_validper -- 合格投资者有限期
    ,o.elig_inve_src_chn -- 合格投资者来源渠道
    ,o.src_sys_num -- 来源系统编号
    ,o.last_updated_src_sys_num -- 最新更新源系统编号
    ,o.revenue_currency -- 收入币种
    ,o.belong_indus_cd -- 所属行业类型
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.eifs_t01_per_cust_ext_info_bk o
    left join ${iol_schema}.eifs_t01_per_cust_ext_info_op n
        on
            o.party_id = n.party_id
            and o.updated_ts = n.updated_ts
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t01_per_cust_ext_info_cl d
        on
            o.party_id = d.party_id
            and o.updated_ts = d.updated_ts
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.eifs_t01_per_cust_ext_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('eifs_t01_per_cust_ext_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.eifs_t01_per_cust_ext_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.eifs_t01_per_cust_ext_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.eifs_t01_per_cust_ext_info exchange partition p_${batch_date} with table ${iol_schema}.eifs_t01_per_cust_ext_info_cl;
alter table ${iol_schema}.eifs_t01_per_cust_ext_info exchange partition p_20991231 with table ${iol_schema}.eifs_t01_per_cust_ext_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t01_per_cust_ext_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t01_per_cust_ext_info_op purge;
drop table ${iol_schema}.eifs_t01_per_cust_ext_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t01_per_cust_ext_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t01_per_cust_ext_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
