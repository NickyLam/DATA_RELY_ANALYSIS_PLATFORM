/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t01_corp_rel_corp_info
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
create table ${iol_schema}.eifs_t01_corp_rel_corp_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t01_corp_rel_corp_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t01_corp_rel_corp_info_op purge;
drop table ${iol_schema}.eifs_t01_corp_rel_corp_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_corp_rel_corp_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t01_corp_rel_corp_info where 0=1;

create table ${iol_schema}.eifs_t01_corp_rel_corp_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t01_corp_rel_corp_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t01_corp_rel_corp_info_cl(
            rel_enterp_id -- 关系企业id
            ,party_id -- 参与人id
            ,rela_cust_rela_cd -- 关联方关系
            ,rela_num -- 关联方编号
            ,party_relationship_type_id -- 关系大类型
            ,rela_name -- 关联方名称
            ,rela_cert_type_cd -- 关联方证件类型
            ,rela_cert_num -- 关联方证件号码
            ,exp_date_of_rela_cert -- 关联方证件失效日期
            ,rela_addr -- 关联方联系地址
            ,rela_tel_num -- 关联方联系电话
            ,rela_stat_cd -- 关联关系状态
            ,tax_pay_ctzn_idnt -- 税收居民身份
            ,rela_group_num -- 关联方集团号
            ,rela_nation_cd -- 关联方国籍
            ,contri_ratio -- 出资比例
            ,hold_stock_amount -- 持股数量
            ,hold_stock_ratio -- 持股比例
            ,oper_timelimit -- 经营期限
            ,corp_found_dt -- 企业成立日期
            ,legal_rep_name -- 法定代表人名称
            ,leg_repres_cert_type -- 法定代表人证件种类
            ,leg_repres_cert_no -- 法定代表人证件号码
            ,legal_cert_valid_date -- 法定代表人证件有效日期
            ,legal_person_tel_no -- 法定代表人联系电话
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
            ,assoc_open_lice -- 关联方开户许可证
            ,superior_org_code -- 上级机构组织机构代码
            ,superior_org_credit_code -- 上级机构信用代码
            ,competent_org_reg_currency -- 主管单位注册币种
            ,competent_org_reg_amt -- 主管单位注册金额
            ,rela_zone_code -- 关联人电话国内区号
            ,phone_no -- 手机号码
            ,mobile_phone -- 联系手机
            ,rela_cert_effect_dt -- 关联人证件生效日期
            ,ctrler_typ_cd -- 控制人类型代码
            ,shrh_typ_cd -- 股东类型
            ,shrh_flag_new -- 是否本行股东标志
            ,role_type_id_to -- 关系小类
            ,lnkm_self_cert_decl_flg -- 关联人自证声明标志
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t01_corp_rel_corp_info_op(
            rel_enterp_id -- 关系企业id
            ,party_id -- 参与人id
            ,rela_cust_rela_cd -- 关联方关系
            ,rela_num -- 关联方编号
            ,party_relationship_type_id -- 关系大类型
            ,rela_name -- 关联方名称
            ,rela_cert_type_cd -- 关联方证件类型
            ,rela_cert_num -- 关联方证件号码
            ,exp_date_of_rela_cert -- 关联方证件失效日期
            ,rela_addr -- 关联方联系地址
            ,rela_tel_num -- 关联方联系电话
            ,rela_stat_cd -- 关联关系状态
            ,tax_pay_ctzn_idnt -- 税收居民身份
            ,rela_group_num -- 关联方集团号
            ,rela_nation_cd -- 关联方国籍
            ,contri_ratio -- 出资比例
            ,hold_stock_amount -- 持股数量
            ,hold_stock_ratio -- 持股比例
            ,oper_timelimit -- 经营期限
            ,corp_found_dt -- 企业成立日期
            ,legal_rep_name -- 法定代表人名称
            ,leg_repres_cert_type -- 法定代表人证件种类
            ,leg_repres_cert_no -- 法定代表人证件号码
            ,legal_cert_valid_date -- 法定代表人证件有效日期
            ,legal_person_tel_no -- 法定代表人联系电话
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
            ,assoc_open_lice -- 关联方开户许可证
            ,superior_org_code -- 上级机构组织机构代码
            ,superior_org_credit_code -- 上级机构信用代码
            ,competent_org_reg_currency -- 主管单位注册币种
            ,competent_org_reg_amt -- 主管单位注册金额
            ,rela_zone_code -- 关联人电话国内区号
            ,phone_no -- 手机号码
            ,mobile_phone -- 联系手机
            ,rela_cert_effect_dt -- 关联人证件生效日期
            ,ctrler_typ_cd -- 控制人类型代码
            ,shrh_typ_cd -- 股东类型
            ,shrh_flag_new -- 是否本行股东标志
            ,role_type_id_to -- 关系小类
            ,lnkm_self_cert_decl_flg -- 关联人自证声明标志
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.rel_enterp_id, o.rel_enterp_id) as rel_enterp_id -- 关系企业id
    ,nvl(n.party_id, o.party_id) as party_id -- 参与人id
    ,nvl(n.rela_cust_rela_cd, o.rela_cust_rela_cd) as rela_cust_rela_cd -- 关联方关系
    ,nvl(n.rela_num, o.rela_num) as rela_num -- 关联方编号
    ,nvl(n.party_relationship_type_id, o.party_relationship_type_id) as party_relationship_type_id -- 关系大类型
    ,nvl(n.rela_name, o.rela_name) as rela_name -- 关联方名称
    ,nvl(n.rela_cert_type_cd, o.rela_cert_type_cd) as rela_cert_type_cd -- 关联方证件类型
    ,nvl(n.rela_cert_num, o.rela_cert_num) as rela_cert_num -- 关联方证件号码
    ,nvl(n.exp_date_of_rela_cert, o.exp_date_of_rela_cert) as exp_date_of_rela_cert -- 关联方证件失效日期
    ,nvl(n.rela_addr, o.rela_addr) as rela_addr -- 关联方联系地址
    ,nvl(n.rela_tel_num, o.rela_tel_num) as rela_tel_num -- 关联方联系电话
    ,nvl(n.rela_stat_cd, o.rela_stat_cd) as rela_stat_cd -- 关联关系状态
    ,nvl(n.tax_pay_ctzn_idnt, o.tax_pay_ctzn_idnt) as tax_pay_ctzn_idnt -- 税收居民身份
    ,nvl(n.rela_group_num, o.rela_group_num) as rela_group_num -- 关联方集团号
    ,nvl(n.rela_nation_cd, o.rela_nation_cd) as rela_nation_cd -- 关联方国籍
    ,nvl(n.contri_ratio, o.contri_ratio) as contri_ratio -- 出资比例
    ,nvl(n.hold_stock_amount, o.hold_stock_amount) as hold_stock_amount -- 持股数量
    ,nvl(n.hold_stock_ratio, o.hold_stock_ratio) as hold_stock_ratio -- 持股比例
    ,nvl(n.oper_timelimit, o.oper_timelimit) as oper_timelimit -- 经营期限
    ,nvl(n.corp_found_dt, o.corp_found_dt) as corp_found_dt -- 企业成立日期
    ,nvl(n.legal_rep_name, o.legal_rep_name) as legal_rep_name -- 法定代表人名称
    ,nvl(n.leg_repres_cert_type, o.leg_repres_cert_type) as leg_repres_cert_type -- 法定代表人证件种类
    ,nvl(n.leg_repres_cert_no, o.leg_repres_cert_no) as leg_repres_cert_no -- 法定代表人证件号码
    ,nvl(n.legal_cert_valid_date, o.legal_cert_valid_date) as legal_cert_valid_date -- 法定代表人证件有效日期
    ,nvl(n.legal_person_tel_no, o.legal_person_tel_no) as legal_person_tel_no -- 法定代表人联系电话
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
    ,nvl(n.assoc_open_lice, o.assoc_open_lice) as assoc_open_lice -- 关联方开户许可证
    ,nvl(n.superior_org_code, o.superior_org_code) as superior_org_code -- 上级机构组织机构代码
    ,nvl(n.superior_org_credit_code, o.superior_org_credit_code) as superior_org_credit_code -- 上级机构信用代码
    ,nvl(n.competent_org_reg_currency, o.competent_org_reg_currency) as competent_org_reg_currency -- 主管单位注册币种
    ,nvl(n.competent_org_reg_amt, o.competent_org_reg_amt) as competent_org_reg_amt -- 主管单位注册金额
    ,nvl(n.rela_zone_code, o.rela_zone_code) as rela_zone_code -- 关联人电话国内区号
    ,nvl(n.phone_no, o.phone_no) as phone_no -- 手机号码
    ,nvl(n.mobile_phone, o.mobile_phone) as mobile_phone -- 联系手机
    ,nvl(n.rela_cert_effect_dt, o.rela_cert_effect_dt) as rela_cert_effect_dt -- 关联人证件生效日期
    ,nvl(n.ctrler_typ_cd, o.ctrler_typ_cd) as ctrler_typ_cd -- 控制人类型代码
    ,nvl(n.shrh_typ_cd, o.shrh_typ_cd) as shrh_typ_cd -- 股东类型
    ,nvl(n.shrh_flag_new, o.shrh_flag_new) as shrh_flag_new -- 是否本行股东标志
    ,nvl(n.role_type_id_to, o.role_type_id_to) as role_type_id_to -- 关系小类
    ,nvl(n.lnkm_self_cert_decl_flg, o.lnkm_self_cert_decl_flg) as lnkm_self_cert_decl_flg -- 关联人自证声明标志
    ,nvl(n.src_sys_num, o.src_sys_num) as src_sys_num -- 来源系统编号
    ,nvl(n.last_updated_src_sys_num, o.last_updated_src_sys_num) as last_updated_src_sys_num -- 最新更新源系统编号
    ,case when
            n.rel_enterp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.rel_enterp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.rel_enterp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.eifs_t01_corp_rel_corp_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t01_corp_rel_corp_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.rel_enterp_id = n.rel_enterp_id
where (
        o.rel_enterp_id is null
    )
    or (
        n.rel_enterp_id is null
    )
    or (
        o.party_id <> n.party_id
        or o.rela_cust_rela_cd <> n.rela_cust_rela_cd
        or o.rela_num <> n.rela_num
        or o.party_relationship_type_id <> n.party_relationship_type_id
        or o.rela_name <> n.rela_name
        or o.rela_cert_type_cd <> n.rela_cert_type_cd
        or o.rela_cert_num <> n.rela_cert_num
        or o.exp_date_of_rela_cert <> n.exp_date_of_rela_cert
        or o.rela_addr <> n.rela_addr
        or o.rela_tel_num <> n.rela_tel_num
        or o.rela_stat_cd <> n.rela_stat_cd
        or o.tax_pay_ctzn_idnt <> n.tax_pay_ctzn_idnt
        or o.rela_group_num <> n.rela_group_num
        or o.rela_nation_cd <> n.rela_nation_cd
        or o.contri_ratio <> n.contri_ratio
        or o.hold_stock_amount <> n.hold_stock_amount
        or o.hold_stock_ratio <> n.hold_stock_ratio
        or o.oper_timelimit <> n.oper_timelimit
        or o.corp_found_dt <> n.corp_found_dt
        or o.legal_rep_name <> n.legal_rep_name
        or o.leg_repres_cert_type <> n.leg_repres_cert_type
        or o.leg_repres_cert_no <> n.leg_repres_cert_no
        or o.legal_cert_valid_date <> n.legal_cert_valid_date
        or o.legal_person_tel_no <> n.legal_person_tel_no
        or o.create_te <> n.create_te
        or o.create_org <> n.create_org
        or o.init_system_id <> n.init_system_id
        or o.init_created_ts <> n.init_created_ts
        or o.created_ts <> n.created_ts
        or o.updated_ts <> n.updated_ts
        or o.last_updated_te <> n.last_updated_te
        or o.last_updated_org <> n.last_updated_org
        or o.last_system_id <> n.last_system_id
        or o.last_updated_ts <> n.last_updated_ts
        or o.assoc_open_lice <> n.assoc_open_lice
        or o.superior_org_code <> n.superior_org_code
        or o.superior_org_credit_code <> n.superior_org_credit_code
        or o.competent_org_reg_currency <> n.competent_org_reg_currency
        or o.competent_org_reg_amt <> n.competent_org_reg_amt
        or o.rela_zone_code <> n.rela_zone_code
        or o.phone_no <> n.phone_no
        or o.mobile_phone <> n.mobile_phone
        or o.rela_cert_effect_dt <> n.rela_cert_effect_dt
        or o.ctrler_typ_cd <> n.ctrler_typ_cd
        or o.shrh_typ_cd <> n.shrh_typ_cd
        or o.shrh_flag_new <> n.shrh_flag_new
        or o.role_type_id_to <> n.role_type_id_to
        or o.lnkm_self_cert_decl_flg <> n.lnkm_self_cert_decl_flg
        or o.src_sys_num <> n.src_sys_num
        or o.last_updated_src_sys_num <> n.last_updated_src_sys_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t01_corp_rel_corp_info_cl(
            rel_enterp_id -- 关系企业id
            ,party_id -- 参与人id
            ,rela_cust_rela_cd -- 关联方关系
            ,rela_num -- 关联方编号
            ,party_relationship_type_id -- 关系大类型
            ,rela_name -- 关联方名称
            ,rela_cert_type_cd -- 关联方证件类型
            ,rela_cert_num -- 关联方证件号码
            ,exp_date_of_rela_cert -- 关联方证件失效日期
            ,rela_addr -- 关联方联系地址
            ,rela_tel_num -- 关联方联系电话
            ,rela_stat_cd -- 关联关系状态
            ,tax_pay_ctzn_idnt -- 税收居民身份
            ,rela_group_num -- 关联方集团号
            ,rela_nation_cd -- 关联方国籍
            ,contri_ratio -- 出资比例
            ,hold_stock_amount -- 持股数量
            ,hold_stock_ratio -- 持股比例
            ,oper_timelimit -- 经营期限
            ,corp_found_dt -- 企业成立日期
            ,legal_rep_name -- 法定代表人名称
            ,leg_repres_cert_type -- 法定代表人证件种类
            ,leg_repres_cert_no -- 法定代表人证件号码
            ,legal_cert_valid_date -- 法定代表人证件有效日期
            ,legal_person_tel_no -- 法定代表人联系电话
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
            ,assoc_open_lice -- 关联方开户许可证
            ,superior_org_code -- 上级机构组织机构代码
            ,superior_org_credit_code -- 上级机构信用代码
            ,competent_org_reg_currency -- 主管单位注册币种
            ,competent_org_reg_amt -- 主管单位注册金额
            ,rela_zone_code -- 关联人电话国内区号
            ,phone_no -- 手机号码
            ,mobile_phone -- 联系手机
            ,rela_cert_effect_dt -- 关联人证件生效日期
            ,ctrler_typ_cd -- 控制人类型代码
            ,shrh_typ_cd -- 股东类型
            ,shrh_flag_new -- 是否本行股东标志
            ,role_type_id_to -- 关系小类
            ,lnkm_self_cert_decl_flg -- 关联人自证声明标志
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t01_corp_rel_corp_info_op(
            rel_enterp_id -- 关系企业id
            ,party_id -- 参与人id
            ,rela_cust_rela_cd -- 关联方关系
            ,rela_num -- 关联方编号
            ,party_relationship_type_id -- 关系大类型
            ,rela_name -- 关联方名称
            ,rela_cert_type_cd -- 关联方证件类型
            ,rela_cert_num -- 关联方证件号码
            ,exp_date_of_rela_cert -- 关联方证件失效日期
            ,rela_addr -- 关联方联系地址
            ,rela_tel_num -- 关联方联系电话
            ,rela_stat_cd -- 关联关系状态
            ,tax_pay_ctzn_idnt -- 税收居民身份
            ,rela_group_num -- 关联方集团号
            ,rela_nation_cd -- 关联方国籍
            ,contri_ratio -- 出资比例
            ,hold_stock_amount -- 持股数量
            ,hold_stock_ratio -- 持股比例
            ,oper_timelimit -- 经营期限
            ,corp_found_dt -- 企业成立日期
            ,legal_rep_name -- 法定代表人名称
            ,leg_repres_cert_type -- 法定代表人证件种类
            ,leg_repres_cert_no -- 法定代表人证件号码
            ,legal_cert_valid_date -- 法定代表人证件有效日期
            ,legal_person_tel_no -- 法定代表人联系电话
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
            ,assoc_open_lice -- 关联方开户许可证
            ,superior_org_code -- 上级机构组织机构代码
            ,superior_org_credit_code -- 上级机构信用代码
            ,competent_org_reg_currency -- 主管单位注册币种
            ,competent_org_reg_amt -- 主管单位注册金额
            ,rela_zone_code -- 关联人电话国内区号
            ,phone_no -- 手机号码
            ,mobile_phone -- 联系手机
            ,rela_cert_effect_dt -- 关联人证件生效日期
            ,ctrler_typ_cd -- 控制人类型代码
            ,shrh_typ_cd -- 股东类型
            ,shrh_flag_new -- 是否本行股东标志
            ,role_type_id_to -- 关系小类
            ,lnkm_self_cert_decl_flg -- 关联人自证声明标志
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.rel_enterp_id -- 关系企业id
    ,o.party_id -- 参与人id
    ,o.rela_cust_rela_cd -- 关联方关系
    ,o.rela_num -- 关联方编号
    ,o.party_relationship_type_id -- 关系大类型
    ,o.rela_name -- 关联方名称
    ,o.rela_cert_type_cd -- 关联方证件类型
    ,o.rela_cert_num -- 关联方证件号码
    ,o.exp_date_of_rela_cert -- 关联方证件失效日期
    ,o.rela_addr -- 关联方联系地址
    ,o.rela_tel_num -- 关联方联系电话
    ,o.rela_stat_cd -- 关联关系状态
    ,o.tax_pay_ctzn_idnt -- 税收居民身份
    ,o.rela_group_num -- 关联方集团号
    ,o.rela_nation_cd -- 关联方国籍
    ,o.contri_ratio -- 出资比例
    ,o.hold_stock_amount -- 持股数量
    ,o.hold_stock_ratio -- 持股比例
    ,o.oper_timelimit -- 经营期限
    ,o.corp_found_dt -- 企业成立日期
    ,o.legal_rep_name -- 法定代表人名称
    ,o.leg_repres_cert_type -- 法定代表人证件种类
    ,o.leg_repres_cert_no -- 法定代表人证件号码
    ,o.legal_cert_valid_date -- 法定代表人证件有效日期
    ,o.legal_person_tel_no -- 法定代表人联系电话
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
    ,o.assoc_open_lice -- 关联方开户许可证
    ,o.superior_org_code -- 上级机构组织机构代码
    ,o.superior_org_credit_code -- 上级机构信用代码
    ,o.competent_org_reg_currency -- 主管单位注册币种
    ,o.competent_org_reg_amt -- 主管单位注册金额
    ,o.rela_zone_code -- 关联人电话国内区号
    ,o.phone_no -- 手机号码
    ,o.mobile_phone -- 联系手机
    ,o.rela_cert_effect_dt -- 关联人证件生效日期
    ,o.ctrler_typ_cd -- 控制人类型代码
    ,o.shrh_typ_cd -- 股东类型
    ,o.shrh_flag_new -- 是否本行股东标志
    ,o.role_type_id_to -- 关系小类
    ,o.lnkm_self_cert_decl_flg -- 关联人自证声明标志
    ,o.src_sys_num -- 来源系统编号
    ,o.last_updated_src_sys_num -- 最新更新源系统编号
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
from ${iol_schema}.eifs_t01_corp_rel_corp_info_bk o
    left join ${iol_schema}.eifs_t01_corp_rel_corp_info_op n
        on
            o.rel_enterp_id = n.rel_enterp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t01_corp_rel_corp_info_cl d
        on
            o.rel_enterp_id = d.rel_enterp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.eifs_t01_corp_rel_corp_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('eifs_t01_corp_rel_corp_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.eifs_t01_corp_rel_corp_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.eifs_t01_corp_rel_corp_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.eifs_t01_corp_rel_corp_info exchange partition p_${batch_date} with table ${iol_schema}.eifs_t01_corp_rel_corp_info_cl;
alter table ${iol_schema}.eifs_t01_corp_rel_corp_info exchange partition p_20991231 with table ${iol_schema}.eifs_t01_corp_rel_corp_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t01_corp_rel_corp_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t01_corp_rel_corp_info_op purge;
drop table ${iol_schema}.eifs_t01_corp_rel_corp_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t01_corp_rel_corp_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t01_corp_rel_corp_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
