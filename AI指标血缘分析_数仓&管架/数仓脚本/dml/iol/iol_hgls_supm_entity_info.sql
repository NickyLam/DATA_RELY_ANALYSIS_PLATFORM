/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_hgls_supm_entity_info
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
create table ${iol_schema}.hgls_supm_entity_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.hgls_supm_entity_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_supm_entity_info_op purge;
drop table ${iol_schema}.hgls_supm_entity_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_supm_entity_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_supm_entity_info where 0=1;

create table ${iol_schema}.hgls_supm_entity_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_supm_entity_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_supm_entity_info_cl(
            id -- 
            ,code -- 
            ,req_code -- 进件code
            ,biz_due_day -- 营业到期日
            ,wthr_tech_inovt_corp -- 是否科创类企业xdfhs
            ,wthr_high_tech_corp -- 是否高新技术企业xdfhs
            ,wthr_tech_corp -- 是否科技型企业xdfhs
            ,wthr_inovt_smc -- 是否创新型中小企业xdfhs
            ,wthr_spec_giant_corp -- 是否专精特新“小巨人”企业xdfhs
            ,wthr_spec_small_mdl_corp -- 是否“专精特新”中小企业
            ,wthr_tech_small_mdl_corp -- 是否科技型中小企业xdfhs
            ,wthr_indu_sing_chmpn_corp -- 是否制造业单项冠军企业xdfhs
            ,wthr_natn_tech_inovt_corp -- 是否国家技术创新示范企业xdfhs
            ,create_date -- 
            ,update_date -- 更新时间
            ,is_del -- 
            ,biz_start_day -- 营业起始日
            ,cit_num -- 中征码
            ,corp_email -- 公司E－Mail：必填，字段上限200位
            ,cont_tel -- 联系电话：必填，字段上限13位
            ,zipcode -- 邮政编码：必填，字段上限10位
            ,frame_org_categ -- 组织机构类别
            ,main_oper_biz -- 主营业务：必填，字段上限20位
            ,wthr_invt_type_pty -- 是否为投资类客户：必选，是/否
            ,go_pub_corp_typ -- 上市类型：必选，单选
            ,pty_ml_risk_class -- 反洗钱风险等级：必选，单选
            ,strg_emg_indu_typ -- 战略新兴产业类型：必选，单选
            ,wthr_blng_two_high_one_rema_indus -- 是否属于两高一剩行业：必选，是/否
            ,wthr_gover_fin_platf -- 是否政府融资平台：必选，是/否
            ,wthr_assoc -- 是否关联方：必选，是/否
            ,wthr_rural_corp -- 是否农村企业：必选，是/否
            ,wthr_ipo_corp -- 是否上市公司：必选，是/否
            ,corp_reg_typ -- 登记注册类型：必选
            ,loan_usage_cd -- 贷款用途类型：必选
            ,oper_corp_wthr_spec_new -- 经营企业是否涉及专精特新
            ,wthr_scntf_crea_corp -- 是否科创企业
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_supm_entity_info_op(
            id -- 
            ,code -- 
            ,req_code -- 进件code
            ,biz_due_day -- 营业到期日
            ,wthr_tech_inovt_corp -- 是否科创类企业xdfhs
            ,wthr_high_tech_corp -- 是否高新技术企业xdfhs
            ,wthr_tech_corp -- 是否科技型企业xdfhs
            ,wthr_inovt_smc -- 是否创新型中小企业xdfhs
            ,wthr_spec_giant_corp -- 是否专精特新“小巨人”企业xdfhs
            ,wthr_spec_small_mdl_corp -- 是否“专精特新”中小企业
            ,wthr_tech_small_mdl_corp -- 是否科技型中小企业xdfhs
            ,wthr_indu_sing_chmpn_corp -- 是否制造业单项冠军企业xdfhs
            ,wthr_natn_tech_inovt_corp -- 是否国家技术创新示范企业xdfhs
            ,create_date -- 
            ,update_date -- 更新时间
            ,is_del -- 
            ,biz_start_day -- 营业起始日
            ,cit_num -- 中征码
            ,corp_email -- 公司E－Mail：必填，字段上限200位
            ,cont_tel -- 联系电话：必填，字段上限13位
            ,zipcode -- 邮政编码：必填，字段上限10位
            ,frame_org_categ -- 组织机构类别
            ,main_oper_biz -- 主营业务：必填，字段上限20位
            ,wthr_invt_type_pty -- 是否为投资类客户：必选，是/否
            ,go_pub_corp_typ -- 上市类型：必选，单选
            ,pty_ml_risk_class -- 反洗钱风险等级：必选，单选
            ,strg_emg_indu_typ -- 战略新兴产业类型：必选，单选
            ,wthr_blng_two_high_one_rema_indus -- 是否属于两高一剩行业：必选，是/否
            ,wthr_gover_fin_platf -- 是否政府融资平台：必选，是/否
            ,wthr_assoc -- 是否关联方：必选，是/否
            ,wthr_rural_corp -- 是否农村企业：必选，是/否
            ,wthr_ipo_corp -- 是否上市公司：必选，是/否
            ,corp_reg_typ -- 登记注册类型：必选
            ,loan_usage_cd -- 贷款用途类型：必选
            ,oper_corp_wthr_spec_new -- 经营企业是否涉及专精特新
            ,wthr_scntf_crea_corp -- 是否科创企业
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.code, o.code) as code -- 
    ,nvl(n.req_code, o.req_code) as req_code -- 进件code
    ,nvl(n.biz_due_day, o.biz_due_day) as biz_due_day -- 营业到期日
    ,nvl(n.wthr_tech_inovt_corp, o.wthr_tech_inovt_corp) as wthr_tech_inovt_corp -- 是否科创类企业xdfhs
    ,nvl(n.wthr_high_tech_corp, o.wthr_high_tech_corp) as wthr_high_tech_corp -- 是否高新技术企业xdfhs
    ,nvl(n.wthr_tech_corp, o.wthr_tech_corp) as wthr_tech_corp -- 是否科技型企业xdfhs
    ,nvl(n.wthr_inovt_smc, o.wthr_inovt_smc) as wthr_inovt_smc -- 是否创新型中小企业xdfhs
    ,nvl(n.wthr_spec_giant_corp, o.wthr_spec_giant_corp) as wthr_spec_giant_corp -- 是否专精特新“小巨人”企业xdfhs
    ,nvl(n.wthr_spec_small_mdl_corp, o.wthr_spec_small_mdl_corp) as wthr_spec_small_mdl_corp -- 是否“专精特新”中小企业
    ,nvl(n.wthr_tech_small_mdl_corp, o.wthr_tech_small_mdl_corp) as wthr_tech_small_mdl_corp -- 是否科技型中小企业xdfhs
    ,nvl(n.wthr_indu_sing_chmpn_corp, o.wthr_indu_sing_chmpn_corp) as wthr_indu_sing_chmpn_corp -- 是否制造业单项冠军企业xdfhs
    ,nvl(n.wthr_natn_tech_inovt_corp, o.wthr_natn_tech_inovt_corp) as wthr_natn_tech_inovt_corp -- 是否国家技术创新示范企业xdfhs
    ,nvl(n.create_date, o.create_date) as create_date -- 
    ,nvl(n.update_date, o.update_date) as update_date -- 更新时间
    ,nvl(n.is_del, o.is_del) as is_del -- 
    ,nvl(n.biz_start_day, o.biz_start_day) as biz_start_day -- 营业起始日
    ,nvl(n.cit_num, o.cit_num) as cit_num -- 中征码
    ,nvl(n.corp_email, o.corp_email) as corp_email -- 公司E－Mail：必填，字段上限200位
    ,nvl(n.cont_tel, o.cont_tel) as cont_tel -- 联系电话：必填，字段上限13位
    ,nvl(n.zipcode, o.zipcode) as zipcode -- 邮政编码：必填，字段上限10位
    ,nvl(n.frame_org_categ, o.frame_org_categ) as frame_org_categ -- 组织机构类别
    ,nvl(n.main_oper_biz, o.main_oper_biz) as main_oper_biz -- 主营业务：必填，字段上限20位
    ,nvl(n.wthr_invt_type_pty, o.wthr_invt_type_pty) as wthr_invt_type_pty -- 是否为投资类客户：必选，是/否
    ,nvl(n.go_pub_corp_typ, o.go_pub_corp_typ) as go_pub_corp_typ -- 上市类型：必选，单选
    ,nvl(n.pty_ml_risk_class, o.pty_ml_risk_class) as pty_ml_risk_class -- 反洗钱风险等级：必选，单选
    ,nvl(n.strg_emg_indu_typ, o.strg_emg_indu_typ) as strg_emg_indu_typ -- 战略新兴产业类型：必选，单选
    ,nvl(n.wthr_blng_two_high_one_rema_indus, o.wthr_blng_two_high_one_rema_indus) as wthr_blng_two_high_one_rema_indus -- 是否属于两高一剩行业：必选，是/否
    ,nvl(n.wthr_gover_fin_platf, o.wthr_gover_fin_platf) as wthr_gover_fin_platf -- 是否政府融资平台：必选，是/否
    ,nvl(n.wthr_assoc, o.wthr_assoc) as wthr_assoc -- 是否关联方：必选，是/否
    ,nvl(n.wthr_rural_corp, o.wthr_rural_corp) as wthr_rural_corp -- 是否农村企业：必选，是/否
    ,nvl(n.wthr_ipo_corp, o.wthr_ipo_corp) as wthr_ipo_corp -- 是否上市公司：必选，是/否
    ,nvl(n.corp_reg_typ, o.corp_reg_typ) as corp_reg_typ -- 登记注册类型：必选
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途类型：必选
    ,nvl(n.oper_corp_wthr_spec_new, o.oper_corp_wthr_spec_new) as oper_corp_wthr_spec_new -- 经营企业是否涉及专精特新
    ,nvl(n.wthr_scntf_crea_corp, o.wthr_scntf_crea_corp) as wthr_scntf_crea_corp -- 是否科创企业
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.hgls_supm_entity_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.hgls_supm_entity_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.code <> n.code
        or o.req_code <> n.req_code
        or o.biz_due_day <> n.biz_due_day
        or o.wthr_tech_inovt_corp <> n.wthr_tech_inovt_corp
        or o.wthr_high_tech_corp <> n.wthr_high_tech_corp
        or o.wthr_tech_corp <> n.wthr_tech_corp
        or o.wthr_inovt_smc <> n.wthr_inovt_smc
        or o.wthr_spec_giant_corp <> n.wthr_spec_giant_corp
        or o.wthr_spec_small_mdl_corp <> n.wthr_spec_small_mdl_corp
        or o.wthr_tech_small_mdl_corp <> n.wthr_tech_small_mdl_corp
        or o.wthr_indu_sing_chmpn_corp <> n.wthr_indu_sing_chmpn_corp
        or o.wthr_natn_tech_inovt_corp <> n.wthr_natn_tech_inovt_corp
        or o.create_date <> n.create_date
        or o.update_date <> n.update_date
        or o.is_del <> n.is_del
        or o.biz_start_day <> n.biz_start_day
        or o.cit_num <> n.cit_num
        or o.corp_email <> n.corp_email
        or o.cont_tel <> n.cont_tel
        or o.zipcode <> n.zipcode
        or o.frame_org_categ <> n.frame_org_categ
        or o.main_oper_biz <> n.main_oper_biz
        or o.wthr_invt_type_pty <> n.wthr_invt_type_pty
        or o.go_pub_corp_typ <> n.go_pub_corp_typ
        or o.pty_ml_risk_class <> n.pty_ml_risk_class
        or o.strg_emg_indu_typ <> n.strg_emg_indu_typ
        or o.wthr_blng_two_high_one_rema_indus <> n.wthr_blng_two_high_one_rema_indus
        or o.wthr_gover_fin_platf <> n.wthr_gover_fin_platf
        or o.wthr_assoc <> n.wthr_assoc
        or o.wthr_rural_corp <> n.wthr_rural_corp
        or o.wthr_ipo_corp <> n.wthr_ipo_corp
        or o.corp_reg_typ <> n.corp_reg_typ
        or o.loan_usage_cd <> n.loan_usage_cd
        or o.oper_corp_wthr_spec_new <> n.oper_corp_wthr_spec_new
        or o.wthr_scntf_crea_corp <> n.wthr_scntf_crea_corp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_supm_entity_info_cl(
            id -- 
            ,code -- 
            ,req_code -- 进件code
            ,biz_due_day -- 营业到期日
            ,wthr_tech_inovt_corp -- 是否科创类企业xdfhs
            ,wthr_high_tech_corp -- 是否高新技术企业xdfhs
            ,wthr_tech_corp -- 是否科技型企业xdfhs
            ,wthr_inovt_smc -- 是否创新型中小企业xdfhs
            ,wthr_spec_giant_corp -- 是否专精特新“小巨人”企业xdfhs
            ,wthr_spec_small_mdl_corp -- 是否“专精特新”中小企业
            ,wthr_tech_small_mdl_corp -- 是否科技型中小企业xdfhs
            ,wthr_indu_sing_chmpn_corp -- 是否制造业单项冠军企业xdfhs
            ,wthr_natn_tech_inovt_corp -- 是否国家技术创新示范企业xdfhs
            ,create_date -- 
            ,update_date -- 更新时间
            ,is_del -- 
            ,biz_start_day -- 营业起始日
            ,cit_num -- 中征码
            ,corp_email -- 公司E－Mail：必填，字段上限200位
            ,cont_tel -- 联系电话：必填，字段上限13位
            ,zipcode -- 邮政编码：必填，字段上限10位
            ,frame_org_categ -- 组织机构类别
            ,main_oper_biz -- 主营业务：必填，字段上限20位
            ,wthr_invt_type_pty -- 是否为投资类客户：必选，是/否
            ,go_pub_corp_typ -- 上市类型：必选，单选
            ,pty_ml_risk_class -- 反洗钱风险等级：必选，单选
            ,strg_emg_indu_typ -- 战略新兴产业类型：必选，单选
            ,wthr_blng_two_high_one_rema_indus -- 是否属于两高一剩行业：必选，是/否
            ,wthr_gover_fin_platf -- 是否政府融资平台：必选，是/否
            ,wthr_assoc -- 是否关联方：必选，是/否
            ,wthr_rural_corp -- 是否农村企业：必选，是/否
            ,wthr_ipo_corp -- 是否上市公司：必选，是/否
            ,corp_reg_typ -- 登记注册类型：必选
            ,loan_usage_cd -- 贷款用途类型：必选
            ,oper_corp_wthr_spec_new -- 经营企业是否涉及专精特新
            ,wthr_scntf_crea_corp -- 是否科创企业
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_supm_entity_info_op(
            id -- 
            ,code -- 
            ,req_code -- 进件code
            ,biz_due_day -- 营业到期日
            ,wthr_tech_inovt_corp -- 是否科创类企业xdfhs
            ,wthr_high_tech_corp -- 是否高新技术企业xdfhs
            ,wthr_tech_corp -- 是否科技型企业xdfhs
            ,wthr_inovt_smc -- 是否创新型中小企业xdfhs
            ,wthr_spec_giant_corp -- 是否专精特新“小巨人”企业xdfhs
            ,wthr_spec_small_mdl_corp -- 是否“专精特新”中小企业
            ,wthr_tech_small_mdl_corp -- 是否科技型中小企业xdfhs
            ,wthr_indu_sing_chmpn_corp -- 是否制造业单项冠军企业xdfhs
            ,wthr_natn_tech_inovt_corp -- 是否国家技术创新示范企业xdfhs
            ,create_date -- 
            ,update_date -- 更新时间
            ,is_del -- 
            ,biz_start_day -- 营业起始日
            ,cit_num -- 中征码
            ,corp_email -- 公司E－Mail：必填，字段上限200位
            ,cont_tel -- 联系电话：必填，字段上限13位
            ,zipcode -- 邮政编码：必填，字段上限10位
            ,frame_org_categ -- 组织机构类别
            ,main_oper_biz -- 主营业务：必填，字段上限20位
            ,wthr_invt_type_pty -- 是否为投资类客户：必选，是/否
            ,go_pub_corp_typ -- 上市类型：必选，单选
            ,pty_ml_risk_class -- 反洗钱风险等级：必选，单选
            ,strg_emg_indu_typ -- 战略新兴产业类型：必选，单选
            ,wthr_blng_two_high_one_rema_indus -- 是否属于两高一剩行业：必选，是/否
            ,wthr_gover_fin_platf -- 是否政府融资平台：必选，是/否
            ,wthr_assoc -- 是否关联方：必选，是/否
            ,wthr_rural_corp -- 是否农村企业：必选，是/否
            ,wthr_ipo_corp -- 是否上市公司：必选，是/否
            ,corp_reg_typ -- 登记注册类型：必选
            ,loan_usage_cd -- 贷款用途类型：必选
            ,oper_corp_wthr_spec_new -- 经营企业是否涉及专精特新
            ,wthr_scntf_crea_corp -- 是否科创企业
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.code -- 
    ,o.req_code -- 进件code
    ,o.biz_due_day -- 营业到期日
    ,o.wthr_tech_inovt_corp -- 是否科创类企业xdfhs
    ,o.wthr_high_tech_corp -- 是否高新技术企业xdfhs
    ,o.wthr_tech_corp -- 是否科技型企业xdfhs
    ,o.wthr_inovt_smc -- 是否创新型中小企业xdfhs
    ,o.wthr_spec_giant_corp -- 是否专精特新“小巨人”企业xdfhs
    ,o.wthr_spec_small_mdl_corp -- 是否“专精特新”中小企业
    ,o.wthr_tech_small_mdl_corp -- 是否科技型中小企业xdfhs
    ,o.wthr_indu_sing_chmpn_corp -- 是否制造业单项冠军企业xdfhs
    ,o.wthr_natn_tech_inovt_corp -- 是否国家技术创新示范企业xdfhs
    ,o.create_date -- 
    ,o.update_date -- 更新时间
    ,o.is_del -- 
    ,o.biz_start_day -- 营业起始日
    ,o.cit_num -- 中征码
    ,o.corp_email -- 公司E－Mail：必填，字段上限200位
    ,o.cont_tel -- 联系电话：必填，字段上限13位
    ,o.zipcode -- 邮政编码：必填，字段上限10位
    ,o.frame_org_categ -- 组织机构类别
    ,o.main_oper_biz -- 主营业务：必填，字段上限20位
    ,o.wthr_invt_type_pty -- 是否为投资类客户：必选，是/否
    ,o.go_pub_corp_typ -- 上市类型：必选，单选
    ,o.pty_ml_risk_class -- 反洗钱风险等级：必选，单选
    ,o.strg_emg_indu_typ -- 战略新兴产业类型：必选，单选
    ,o.wthr_blng_two_high_one_rema_indus -- 是否属于两高一剩行业：必选，是/否
    ,o.wthr_gover_fin_platf -- 是否政府融资平台：必选，是/否
    ,o.wthr_assoc -- 是否关联方：必选，是/否
    ,o.wthr_rural_corp -- 是否农村企业：必选，是/否
    ,o.wthr_ipo_corp -- 是否上市公司：必选，是/否
    ,o.corp_reg_typ -- 登记注册类型：必选
    ,o.loan_usage_cd -- 贷款用途类型：必选
    ,o.oper_corp_wthr_spec_new -- 经营企业是否涉及专精特新
    ,o.wthr_scntf_crea_corp -- 是否科创企业
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
from ${iol_schema}.hgls_supm_entity_info_bk o
    left join ${iol_schema}.hgls_supm_entity_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.hgls_supm_entity_info_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.hgls_supm_entity_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('hgls_supm_entity_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.hgls_supm_entity_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.hgls_supm_entity_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.hgls_supm_entity_info exchange partition p_${batch_date} with table ${iol_schema}.hgls_supm_entity_info_cl;
alter table ${iol_schema}.hgls_supm_entity_info exchange partition p_20991231 with table ${iol_schema}.hgls_supm_entity_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.hgls_supm_entity_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_supm_entity_info_op purge;
drop table ${iol_schema}.hgls_supm_entity_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.hgls_supm_entity_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'hgls_supm_entity_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
