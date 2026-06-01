/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t01_corp_rel_per_info
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
create table ${iol_schema}.eifs_t01_corp_rel_per_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t01_corp_rel_per_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t01_corp_rel_per_info_op purge;
drop table ${iol_schema}.eifs_t01_corp_rel_per_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_corp_rel_per_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t01_corp_rel_per_info where 0=1;

create table ${iol_schema}.eifs_t01_corp_rel_per_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t01_corp_rel_per_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t01_corp_rel_per_info_cl(
            rel_id -- 关系人id
            ,party_id -- 参与人id
            ,rela_cust_rela_cd -- 关联方关系
            ,rela_num -- 关联方编号
            ,party_relationship_type_id -- 关系大类型
            ,rela_name -- 关联方名称
            ,rela_cert_type_cd -- 关联方证件类型
            ,rela_cert_num -- 关联方证件号码
            ,rela_cert_effect_dt -- 关联方证件生效日期
            ,rela_cert_valid -- 关联方证件有效期
            ,exp_date_of_rela_cert -- 关联方证件失效日期
            ,birth_dt -- 出生日期
            ,gender_cd -- 性别
            ,career_cd -- 职业类型
            ,work_corp_name -- 工作单位名称
            ,work_unit_addr -- 工作单位地址
            ,work_unit_property -- 工作单位性质
            ,title_cd -- 职称
            ,pos_level_cd -- 职务类型
            ,mon_in -- 月收入
            ,contri_ratio -- 出资比例
            ,hold_stock_amount -- 持股数量
            ,hold_stock_ratio -- 持股比例
            ,rela_tel_num -- 关联方联系电话
            ,rela_addr -- 关联方联系地址
            ,tax_pay_ctzn_idnt -- 税收居民身份
            ,rela_stat_cd -- 关联关系状态
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
            ,other_pos_level -- 其他职务
            ,rela_qualify -- 关联人最高学历代码
            ,rela_nation_cd -- 关联方国籍
            ,rela_zone_code -- 关联人电话国内区号
            ,phone_no -- 手机号码
            ,mobile_phone -- 联系手机
            ,ctrler_typ_cd -- 控制人类型代码
            ,shrh_typ_cd -- 股东类型
            ,shrh_flag_new -- 是否本行股东标志
            ,role_type_id_to -- 关系小类
            ,lnkm_self_cert_decl_flg -- 关联人自证声明标志
            ,is_org_true_control_per -- 实际控制人标志
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t01_corp_rel_per_info_op(
            rel_id -- 关系人id
            ,party_id -- 参与人id
            ,rela_cust_rela_cd -- 关联方关系
            ,rela_num -- 关联方编号
            ,party_relationship_type_id -- 关系大类型
            ,rela_name -- 关联方名称
            ,rela_cert_type_cd -- 关联方证件类型
            ,rela_cert_num -- 关联方证件号码
            ,rela_cert_effect_dt -- 关联方证件生效日期
            ,rela_cert_valid -- 关联方证件有效期
            ,exp_date_of_rela_cert -- 关联方证件失效日期
            ,birth_dt -- 出生日期
            ,gender_cd -- 性别
            ,career_cd -- 职业类型
            ,work_corp_name -- 工作单位名称
            ,work_unit_addr -- 工作单位地址
            ,work_unit_property -- 工作单位性质
            ,title_cd -- 职称
            ,pos_level_cd -- 职务类型
            ,mon_in -- 月收入
            ,contri_ratio -- 出资比例
            ,hold_stock_amount -- 持股数量
            ,hold_stock_ratio -- 持股比例
            ,rela_tel_num -- 关联方联系电话
            ,rela_addr -- 关联方联系地址
            ,tax_pay_ctzn_idnt -- 税收居民身份
            ,rela_stat_cd -- 关联关系状态
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
            ,other_pos_level -- 其他职务
            ,rela_qualify -- 关联人最高学历代码
            ,rela_nation_cd -- 关联方国籍
            ,rela_zone_code -- 关联人电话国内区号
            ,phone_no -- 手机号码
            ,mobile_phone -- 联系手机
            ,ctrler_typ_cd -- 控制人类型代码
            ,shrh_typ_cd -- 股东类型
            ,shrh_flag_new -- 是否本行股东标志
            ,role_type_id_to -- 关系小类
            ,lnkm_self_cert_decl_flg -- 关联人自证声明标志
            ,is_org_true_control_per -- 实际控制人标志
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.rel_id, o.rel_id) as rel_id -- 关系人id
    ,nvl(n.party_id, o.party_id) as party_id -- 参与人id
    ,nvl(n.rela_cust_rela_cd, o.rela_cust_rela_cd) as rela_cust_rela_cd -- 关联方关系
    ,nvl(n.rela_num, o.rela_num) as rela_num -- 关联方编号
    ,nvl(n.party_relationship_type_id, o.party_relationship_type_id) as party_relationship_type_id -- 关系大类型
    ,nvl(n.rela_name, o.rela_name) as rela_name -- 关联方名称
    ,nvl(n.rela_cert_type_cd, o.rela_cert_type_cd) as rela_cert_type_cd -- 关联方证件类型
    ,nvl(n.rela_cert_num, o.rela_cert_num) as rela_cert_num -- 关联方证件号码
    ,nvl(n.rela_cert_effect_dt, o.rela_cert_effect_dt) as rela_cert_effect_dt -- 关联方证件生效日期
    ,nvl(n.rela_cert_valid, o.rela_cert_valid) as rela_cert_valid -- 关联方证件有效期
    ,nvl(n.exp_date_of_rela_cert, o.exp_date_of_rela_cert) as exp_date_of_rela_cert -- 关联方证件失效日期
    ,nvl(n.birth_dt, o.birth_dt) as birth_dt -- 出生日期
    ,nvl(n.gender_cd, o.gender_cd) as gender_cd -- 性别
    ,nvl(n.career_cd, o.career_cd) as career_cd -- 职业类型
    ,nvl(n.work_corp_name, o.work_corp_name) as work_corp_name -- 工作单位名称
    ,nvl(n.work_unit_addr, o.work_unit_addr) as work_unit_addr -- 工作单位地址
    ,nvl(n.work_unit_property, o.work_unit_property) as work_unit_property -- 工作单位性质
    ,nvl(n.title_cd, o.title_cd) as title_cd -- 职称
    ,nvl(n.pos_level_cd, o.pos_level_cd) as pos_level_cd -- 职务类型
    ,nvl(n.mon_in, o.mon_in) as mon_in -- 月收入
    ,nvl(n.contri_ratio, o.contri_ratio) as contri_ratio -- 出资比例
    ,nvl(n.hold_stock_amount, o.hold_stock_amount) as hold_stock_amount -- 持股数量
    ,nvl(n.hold_stock_ratio, o.hold_stock_ratio) as hold_stock_ratio -- 持股比例
    ,nvl(n.rela_tel_num, o.rela_tel_num) as rela_tel_num -- 关联方联系电话
    ,nvl(n.rela_addr, o.rela_addr) as rela_addr -- 关联方联系地址
    ,nvl(n.tax_pay_ctzn_idnt, o.tax_pay_ctzn_idnt) as tax_pay_ctzn_idnt -- 税收居民身份
    ,nvl(n.rela_stat_cd, o.rela_stat_cd) as rela_stat_cd -- 关联关系状态
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
    ,nvl(n.other_pos_level, o.other_pos_level) as other_pos_level -- 其他职务
    ,nvl(n.rela_qualify, o.rela_qualify) as rela_qualify -- 关联人最高学历代码
    ,nvl(n.rela_nation_cd, o.rela_nation_cd) as rela_nation_cd -- 关联方国籍
    ,nvl(n.rela_zone_code, o.rela_zone_code) as rela_zone_code -- 关联人电话国内区号
    ,nvl(n.phone_no, o.phone_no) as phone_no -- 手机号码
    ,nvl(n.mobile_phone, o.mobile_phone) as mobile_phone -- 联系手机
    ,nvl(n.ctrler_typ_cd, o.ctrler_typ_cd) as ctrler_typ_cd -- 控制人类型代码
    ,nvl(n.shrh_typ_cd, o.shrh_typ_cd) as shrh_typ_cd -- 股东类型
    ,nvl(n.shrh_flag_new, o.shrh_flag_new) as shrh_flag_new -- 是否本行股东标志
    ,nvl(n.role_type_id_to, o.role_type_id_to) as role_type_id_to -- 关系小类
    ,nvl(n.lnkm_self_cert_decl_flg, o.lnkm_self_cert_decl_flg) as lnkm_self_cert_decl_flg -- 关联人自证声明标志
    ,nvl(n.is_org_true_control_per, o.is_org_true_control_per) as is_org_true_control_per -- 实际控制人标志
    ,nvl(n.src_sys_num, o.src_sys_num) as src_sys_num -- 来源系统编号
    ,nvl(n.last_updated_src_sys_num, o.last_updated_src_sys_num) as last_updated_src_sys_num -- 最新更新源系统编号
    ,case when
            n.rel_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.rel_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.rel_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.eifs_t01_corp_rel_per_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t01_corp_rel_per_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.rel_id = n.rel_id
where (
        o.rel_id is null
    )
    or (
        n.rel_id is null
    )
    or (
        o.party_id <> n.party_id
        or o.rela_cust_rela_cd <> n.rela_cust_rela_cd
        or o.rela_num <> n.rela_num
        or o.party_relationship_type_id <> n.party_relationship_type_id
        or o.rela_name <> n.rela_name
        or o.rela_cert_type_cd <> n.rela_cert_type_cd
        or o.rela_cert_num <> n.rela_cert_num
        or o.rela_cert_effect_dt <> n.rela_cert_effect_dt
        or o.rela_cert_valid <> n.rela_cert_valid
        or o.exp_date_of_rela_cert <> n.exp_date_of_rela_cert
        or o.birth_dt <> n.birth_dt
        or o.gender_cd <> n.gender_cd
        or o.career_cd <> n.career_cd
        or o.work_corp_name <> n.work_corp_name
        or o.work_unit_addr <> n.work_unit_addr
        or o.work_unit_property <> n.work_unit_property
        or o.title_cd <> n.title_cd
        or o.pos_level_cd <> n.pos_level_cd
        or o.mon_in <> n.mon_in
        or o.contri_ratio <> n.contri_ratio
        or o.hold_stock_amount <> n.hold_stock_amount
        or o.hold_stock_ratio <> n.hold_stock_ratio
        or o.rela_tel_num <> n.rela_tel_num
        or o.rela_addr <> n.rela_addr
        or o.tax_pay_ctzn_idnt <> n.tax_pay_ctzn_idnt
        or o.rela_stat_cd <> n.rela_stat_cd
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
        or o.other_pos_level <> n.other_pos_level
        or o.rela_qualify <> n.rela_qualify
        or o.rela_nation_cd <> n.rela_nation_cd
        or o.rela_zone_code <> n.rela_zone_code
        or o.phone_no <> n.phone_no
        or o.mobile_phone <> n.mobile_phone
        or o.ctrler_typ_cd <> n.ctrler_typ_cd
        or o.shrh_typ_cd <> n.shrh_typ_cd
        or o.shrh_flag_new <> n.shrh_flag_new
        or o.role_type_id_to <> n.role_type_id_to
        or o.lnkm_self_cert_decl_flg <> n.lnkm_self_cert_decl_flg
        or o.is_org_true_control_per <> n.is_org_true_control_per
        or o.src_sys_num <> n.src_sys_num
        or o.last_updated_src_sys_num <> n.last_updated_src_sys_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t01_corp_rel_per_info_cl(
            rel_id -- 关系人id
            ,party_id -- 参与人id
            ,rela_cust_rela_cd -- 关联方关系
            ,rela_num -- 关联方编号
            ,party_relationship_type_id -- 关系大类型
            ,rela_name -- 关联方名称
            ,rela_cert_type_cd -- 关联方证件类型
            ,rela_cert_num -- 关联方证件号码
            ,rela_cert_effect_dt -- 关联方证件生效日期
            ,rela_cert_valid -- 关联方证件有效期
            ,exp_date_of_rela_cert -- 关联方证件失效日期
            ,birth_dt -- 出生日期
            ,gender_cd -- 性别
            ,career_cd -- 职业类型
            ,work_corp_name -- 工作单位名称
            ,work_unit_addr -- 工作单位地址
            ,work_unit_property -- 工作单位性质
            ,title_cd -- 职称
            ,pos_level_cd -- 职务类型
            ,mon_in -- 月收入
            ,contri_ratio -- 出资比例
            ,hold_stock_amount -- 持股数量
            ,hold_stock_ratio -- 持股比例
            ,rela_tel_num -- 关联方联系电话
            ,rela_addr -- 关联方联系地址
            ,tax_pay_ctzn_idnt -- 税收居民身份
            ,rela_stat_cd -- 关联关系状态
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
            ,other_pos_level -- 其他职务
            ,rela_qualify -- 关联人最高学历代码
            ,rela_nation_cd -- 关联方国籍
            ,rela_zone_code -- 关联人电话国内区号
            ,phone_no -- 手机号码
            ,mobile_phone -- 联系手机
            ,ctrler_typ_cd -- 控制人类型代码
            ,shrh_typ_cd -- 股东类型
            ,shrh_flag_new -- 是否本行股东标志
            ,role_type_id_to -- 关系小类
            ,lnkm_self_cert_decl_flg -- 关联人自证声明标志
            ,is_org_true_control_per -- 实际控制人标志
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t01_corp_rel_per_info_op(
            rel_id -- 关系人id
            ,party_id -- 参与人id
            ,rela_cust_rela_cd -- 关联方关系
            ,rela_num -- 关联方编号
            ,party_relationship_type_id -- 关系大类型
            ,rela_name -- 关联方名称
            ,rela_cert_type_cd -- 关联方证件类型
            ,rela_cert_num -- 关联方证件号码
            ,rela_cert_effect_dt -- 关联方证件生效日期
            ,rela_cert_valid -- 关联方证件有效期
            ,exp_date_of_rela_cert -- 关联方证件失效日期
            ,birth_dt -- 出生日期
            ,gender_cd -- 性别
            ,career_cd -- 职业类型
            ,work_corp_name -- 工作单位名称
            ,work_unit_addr -- 工作单位地址
            ,work_unit_property -- 工作单位性质
            ,title_cd -- 职称
            ,pos_level_cd -- 职务类型
            ,mon_in -- 月收入
            ,contri_ratio -- 出资比例
            ,hold_stock_amount -- 持股数量
            ,hold_stock_ratio -- 持股比例
            ,rela_tel_num -- 关联方联系电话
            ,rela_addr -- 关联方联系地址
            ,tax_pay_ctzn_idnt -- 税收居民身份
            ,rela_stat_cd -- 关联关系状态
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
            ,other_pos_level -- 其他职务
            ,rela_qualify -- 关联人最高学历代码
            ,rela_nation_cd -- 关联方国籍
            ,rela_zone_code -- 关联人电话国内区号
            ,phone_no -- 手机号码
            ,mobile_phone -- 联系手机
            ,ctrler_typ_cd -- 控制人类型代码
            ,shrh_typ_cd -- 股东类型
            ,shrh_flag_new -- 是否本行股东标志
            ,role_type_id_to -- 关系小类
            ,lnkm_self_cert_decl_flg -- 关联人自证声明标志
            ,is_org_true_control_per -- 实际控制人标志
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.rel_id -- 关系人id
    ,o.party_id -- 参与人id
    ,o.rela_cust_rela_cd -- 关联方关系
    ,o.rela_num -- 关联方编号
    ,o.party_relationship_type_id -- 关系大类型
    ,o.rela_name -- 关联方名称
    ,o.rela_cert_type_cd -- 关联方证件类型
    ,o.rela_cert_num -- 关联方证件号码
    ,o.rela_cert_effect_dt -- 关联方证件生效日期
    ,o.rela_cert_valid -- 关联方证件有效期
    ,o.exp_date_of_rela_cert -- 关联方证件失效日期
    ,o.birth_dt -- 出生日期
    ,o.gender_cd -- 性别
    ,o.career_cd -- 职业类型
    ,o.work_corp_name -- 工作单位名称
    ,o.work_unit_addr -- 工作单位地址
    ,o.work_unit_property -- 工作单位性质
    ,o.title_cd -- 职称
    ,o.pos_level_cd -- 职务类型
    ,o.mon_in -- 月收入
    ,o.contri_ratio -- 出资比例
    ,o.hold_stock_amount -- 持股数量
    ,o.hold_stock_ratio -- 持股比例
    ,o.rela_tel_num -- 关联方联系电话
    ,o.rela_addr -- 关联方联系地址
    ,o.tax_pay_ctzn_idnt -- 税收居民身份
    ,o.rela_stat_cd -- 关联关系状态
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
    ,o.other_pos_level -- 其他职务
    ,o.rela_qualify -- 关联人最高学历代码
    ,o.rela_nation_cd -- 关联方国籍
    ,o.rela_zone_code -- 关联人电话国内区号
    ,o.phone_no -- 手机号码
    ,o.mobile_phone -- 联系手机
    ,o.ctrler_typ_cd -- 控制人类型代码
    ,o.shrh_typ_cd -- 股东类型
    ,o.shrh_flag_new -- 是否本行股东标志
    ,o.role_type_id_to -- 关系小类
    ,o.lnkm_self_cert_decl_flg -- 关联人自证声明标志
    ,o.is_org_true_control_per -- 实际控制人标志
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
from ${iol_schema}.eifs_t01_corp_rel_per_info_bk o
    left join ${iol_schema}.eifs_t01_corp_rel_per_info_op n
        on
            o.rel_id = n.rel_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t01_corp_rel_per_info_cl d
        on
            o.rel_id = d.rel_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.eifs_t01_corp_rel_per_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('eifs_t01_corp_rel_per_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.eifs_t01_corp_rel_per_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.eifs_t01_corp_rel_per_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.eifs_t01_corp_rel_per_info exchange partition p_${batch_date} with table ${iol_schema}.eifs_t01_corp_rel_per_info_cl;
alter table ${iol_schema}.eifs_t01_corp_rel_per_info exchange partition p_20991231 with table ${iol_schema}.eifs_t01_corp_rel_per_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t01_corp_rel_per_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t01_corp_rel_per_info_op purge;
drop table ${iol_schema}.eifs_t01_corp_rel_per_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t01_corp_rel_per_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t01_corp_rel_per_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
