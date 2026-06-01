/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_noas_common_orgcode
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
create table ${iol_schema}.noas_common_orgcode_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.noas_common_orgcode
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_common_orgcode_op purge;
drop table ${iol_schema}.noas_common_orgcode_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_common_orgcode_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_common_orgcode where 0=1;

create table ${iol_schema}.noas_common_orgcode_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_common_orgcode where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_common_orgcode_cl(
            organ_code_key -- 机构唯一标识
            ,organ_code -- 内部机构编号
            ,fun_organ -- 职能机构
            ,fun_dep -- 职能部门
            ,zoneno -- 分行号
            ,p_bo_c_financial_code -- 人民银行金融机构编号
            ,financial_code -- 金融机构标识码
            ,s_w_i_f_t_code -- swift号码
            ,bank_code -- 支付系统银行行号
            ,legal -- 法人号
            ,business_license -- 营业执照号码
            ,organization_code -- 组织机构代码
            ,tax_id -- 税务登记证号
            ,organ_cn_full_name -- 组织机构名称
            ,organ_cn_short_name -- 组织机构简称
            ,organ_en_full_name -- 组织机构英文全称
            ,organ_en_short_name -- 组织机构英文简称
            ,organ_state_code -- 机构营业状态
            ,organ_status -- 机构状态
            ,organ_founding_date -- 机构成立日期
            ,organ_close_date -- 机构关闭日期
            ,organ_type -- 组织机构类型
            ,is_st -- 是否为实体机构
            ,is_hs -- 是否为核算机构
            ,is_yy -- 是否为营业机构
            ,is_xz -- 是否为行政机构
            ,is_zw -- 是否为账务机构
            ,organ_level -- 组织机构级别代码
            ,leaf_note_flag -- 叶节点标志
            ,xzup_organ_code -- 行政上级组织机构编码
            ,zwup_organ_code -- 账务上级组织机构编码
            ,hsup_organ_code -- 核算上级组织机构编码
            ,seque -- 机构顺序号
            ,post_code -- 邮政编码
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 所在县/区
            ,address -- 详细地址
            ,email -- 电子邮箱
            ,u_r_l -- 网址
            ,country_code -- 国际长途区号
            ,area_code -- 国内长途区号
            ,phone -- 电话号码
            ,sub_phone -- 分机号
            ,service_phone -- 服务电话
            ,financial_lic_num -- 金融许可证号码
            ,organ_system -- 机构关联系统
            ,last_updated_stamp -- bosent自带最后修改时间
            ,last_updated_tx_stamp -- bosent自带最后修改时间
            ,created_stamp -- bosent自带创建时间
            ,created_tx_stamp -- bosent自带创建时间
            ,orderno -- 显示顺序号
            ,cbrcfininstt_id -- 银监会金融机构编号
            ,union_financial_code -- 银联金融机构编号
            ,isxnhs -- 是否为虚拟核算机构   入职需要
            ,head_emply_id -- 机构类型为核算时，校验为必输
            ,is_business_division -- 是否为事业部
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_common_orgcode_op(
            organ_code_key -- 机构唯一标识
            ,organ_code -- 内部机构编号
            ,fun_organ -- 职能机构
            ,fun_dep -- 职能部门
            ,zoneno -- 分行号
            ,p_bo_c_financial_code -- 人民银行金融机构编号
            ,financial_code -- 金融机构标识码
            ,s_w_i_f_t_code -- swift号码
            ,bank_code -- 支付系统银行行号
            ,legal -- 法人号
            ,business_license -- 营业执照号码
            ,organization_code -- 组织机构代码
            ,tax_id -- 税务登记证号
            ,organ_cn_full_name -- 组织机构名称
            ,organ_cn_short_name -- 组织机构简称
            ,organ_en_full_name -- 组织机构英文全称
            ,organ_en_short_name -- 组织机构英文简称
            ,organ_state_code -- 机构营业状态
            ,organ_status -- 机构状态
            ,organ_founding_date -- 机构成立日期
            ,organ_close_date -- 机构关闭日期
            ,organ_type -- 组织机构类型
            ,is_st -- 是否为实体机构
            ,is_hs -- 是否为核算机构
            ,is_yy -- 是否为营业机构
            ,is_xz -- 是否为行政机构
            ,is_zw -- 是否为账务机构
            ,organ_level -- 组织机构级别代码
            ,leaf_note_flag -- 叶节点标志
            ,xzup_organ_code -- 行政上级组织机构编码
            ,zwup_organ_code -- 账务上级组织机构编码
            ,hsup_organ_code -- 核算上级组织机构编码
            ,seque -- 机构顺序号
            ,post_code -- 邮政编码
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 所在县/区
            ,address -- 详细地址
            ,email -- 电子邮箱
            ,u_r_l -- 网址
            ,country_code -- 国际长途区号
            ,area_code -- 国内长途区号
            ,phone -- 电话号码
            ,sub_phone -- 分机号
            ,service_phone -- 服务电话
            ,financial_lic_num -- 金融许可证号码
            ,organ_system -- 机构关联系统
            ,last_updated_stamp -- bosent自带最后修改时间
            ,last_updated_tx_stamp -- bosent自带最后修改时间
            ,created_stamp -- bosent自带创建时间
            ,created_tx_stamp -- bosent自带创建时间
            ,orderno -- 显示顺序号
            ,cbrcfininstt_id -- 银监会金融机构编号
            ,union_financial_code -- 银联金融机构编号
            ,isxnhs -- 是否为虚拟核算机构   入职需要
            ,head_emply_id -- 机构类型为核算时，校验为必输
            ,is_business_division -- 是否为事业部
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.organ_code_key, o.organ_code_key) as organ_code_key -- 机构唯一标识
    ,nvl(n.organ_code, o.organ_code) as organ_code -- 内部机构编号
    ,nvl(n.fun_organ, o.fun_organ) as fun_organ -- 职能机构
    ,nvl(n.fun_dep, o.fun_dep) as fun_dep -- 职能部门
    ,nvl(n.zoneno, o.zoneno) as zoneno -- 分行号
    ,nvl(n.p_bo_c_financial_code, o.p_bo_c_financial_code) as p_bo_c_financial_code -- 人民银行金融机构编号
    ,nvl(n.financial_code, o.financial_code) as financial_code -- 金融机构标识码
    ,nvl(n.s_w_i_f_t_code, o.s_w_i_f_t_code) as s_w_i_f_t_code -- swift号码
    ,nvl(n.bank_code, o.bank_code) as bank_code -- 支付系统银行行号
    ,nvl(n.legal, o.legal) as legal -- 法人号
    ,nvl(n.business_license, o.business_license) as business_license -- 营业执照号码
    ,nvl(n.organization_code, o.organization_code) as organization_code -- 组织机构代码
    ,nvl(n.tax_id, o.tax_id) as tax_id -- 税务登记证号
    ,nvl(n.organ_cn_full_name, o.organ_cn_full_name) as organ_cn_full_name -- 组织机构名称
    ,nvl(n.organ_cn_short_name, o.organ_cn_short_name) as organ_cn_short_name -- 组织机构简称
    ,nvl(n.organ_en_full_name, o.organ_en_full_name) as organ_en_full_name -- 组织机构英文全称
    ,nvl(n.organ_en_short_name, o.organ_en_short_name) as organ_en_short_name -- 组织机构英文简称
    ,nvl(n.organ_state_code, o.organ_state_code) as organ_state_code -- 机构营业状态
    ,nvl(n.organ_status, o.organ_status) as organ_status -- 机构状态
    ,nvl(n.organ_founding_date, o.organ_founding_date) as organ_founding_date -- 机构成立日期
    ,nvl(n.organ_close_date, o.organ_close_date) as organ_close_date -- 机构关闭日期
    ,nvl(n.organ_type, o.organ_type) as organ_type -- 组织机构类型
    ,nvl(n.is_st, o.is_st) as is_st -- 是否为实体机构
    ,nvl(n.is_hs, o.is_hs) as is_hs -- 是否为核算机构
    ,nvl(n.is_yy, o.is_yy) as is_yy -- 是否为营业机构
    ,nvl(n.is_xz, o.is_xz) as is_xz -- 是否为行政机构
    ,nvl(n.is_zw, o.is_zw) as is_zw -- 是否为账务机构
    ,nvl(n.organ_level, o.organ_level) as organ_level -- 组织机构级别代码
    ,nvl(n.leaf_note_flag, o.leaf_note_flag) as leaf_note_flag -- 叶节点标志
    ,nvl(n.xzup_organ_code, o.xzup_organ_code) as xzup_organ_code -- 行政上级组织机构编码
    ,nvl(n.zwup_organ_code, o.zwup_organ_code) as zwup_organ_code -- 账务上级组织机构编码
    ,nvl(n.hsup_organ_code, o.hsup_organ_code) as hsup_organ_code -- 核算上级组织机构编码
    ,nvl(n.seque, o.seque) as seque -- 机构顺序号
    ,nvl(n.post_code, o.post_code) as post_code -- 邮政编码
    ,nvl(n.country, o.country) as country -- 所在国家
    ,nvl(n.province, o.province) as province -- 所在省/州
    ,nvl(n.city, o.city) as city -- 所在城市
    ,nvl(n.county, o.county) as county -- 所在县/区
    ,nvl(n.address, o.address) as address -- 详细地址
    ,nvl(n.email, o.email) as email -- 电子邮箱
    ,nvl(n.u_r_l, o.u_r_l) as u_r_l -- 网址
    ,nvl(n.country_code, o.country_code) as country_code -- 国际长途区号
    ,nvl(n.area_code, o.area_code) as area_code -- 国内长途区号
    ,nvl(n.phone, o.phone) as phone -- 电话号码
    ,nvl(n.sub_phone, o.sub_phone) as sub_phone -- 分机号
    ,nvl(n.service_phone, o.service_phone) as service_phone -- 服务电话
    ,nvl(n.financial_lic_num, o.financial_lic_num) as financial_lic_num -- 金融许可证号码
    ,nvl(n.organ_system, o.organ_system) as organ_system -- 机构关联系统
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- bosent自带最后修改时间
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- bosent自带最后修改时间
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- bosent自带创建时间
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- bosent自带创建时间
    ,nvl(n.orderno, o.orderno) as orderno -- 显示顺序号
    ,nvl(n.cbrcfininstt_id, o.cbrcfininstt_id) as cbrcfininstt_id -- 银监会金融机构编号
    ,nvl(n.union_financial_code, o.union_financial_code) as union_financial_code -- 银联金融机构编号
    ,nvl(n.isxnhs, o.isxnhs) as isxnhs -- 是否为虚拟核算机构   入职需要
    ,nvl(n.head_emply_id, o.head_emply_id) as head_emply_id -- 机构类型为核算时，校验为必输
    ,nvl(n.is_business_division, o.is_business_division) as is_business_division -- 是否为事业部
    ,case when
            n.organ_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.organ_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.organ_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.noas_common_orgcode_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.noas_common_orgcode where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.organ_code = n.organ_code
where (
        o.organ_code is null
    )
    or (
        n.organ_code is null
    )
    or (
        o.organ_code_key <> n.organ_code_key
        or o.fun_organ <> n.fun_organ
        or o.fun_dep <> n.fun_dep
        or o.zoneno <> n.zoneno
        or o.p_bo_c_financial_code <> n.p_bo_c_financial_code
        or o.financial_code <> n.financial_code
        or o.s_w_i_f_t_code <> n.s_w_i_f_t_code
        or o.bank_code <> n.bank_code
        or o.legal <> n.legal
        or o.business_license <> n.business_license
        or o.organization_code <> n.organization_code
        or o.tax_id <> n.tax_id
        or o.organ_cn_full_name <> n.organ_cn_full_name
        or o.organ_cn_short_name <> n.organ_cn_short_name
        or o.organ_en_full_name <> n.organ_en_full_name
        or o.organ_en_short_name <> n.organ_en_short_name
        or o.organ_state_code <> n.organ_state_code
        or o.organ_status <> n.organ_status
        or o.organ_founding_date <> n.organ_founding_date
        or o.organ_close_date <> n.organ_close_date
        or o.organ_type <> n.organ_type
        or o.is_st <> n.is_st
        or o.is_hs <> n.is_hs
        or o.is_yy <> n.is_yy
        or o.is_xz <> n.is_xz
        or o.is_zw <> n.is_zw
        or o.organ_level <> n.organ_level
        or o.leaf_note_flag <> n.leaf_note_flag
        or o.xzup_organ_code <> n.xzup_organ_code
        or o.zwup_organ_code <> n.zwup_organ_code
        or o.hsup_organ_code <> n.hsup_organ_code
        or o.seque <> n.seque
        or o.post_code <> n.post_code
        or o.country <> n.country
        or o.province <> n.province
        or o.city <> n.city
        or o.county <> n.county
        or o.address <> n.address
        or o.email <> n.email
        or o.u_r_l <> n.u_r_l
        or o.country_code <> n.country_code
        or o.area_code <> n.area_code
        or o.phone <> n.phone
        or o.sub_phone <> n.sub_phone
        or o.service_phone <> n.service_phone
        or o.financial_lic_num <> n.financial_lic_num
        or o.organ_system <> n.organ_system
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
        or o.orderno <> n.orderno
        or o.cbrcfininstt_id <> n.cbrcfininstt_id
        or o.union_financial_code <> n.union_financial_code
        or o.isxnhs <> n.isxnhs
        or o.head_emply_id <> n.head_emply_id
        or o.is_business_division <> n.is_business_division
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_common_orgcode_cl(
            organ_code_key -- 机构唯一标识
            ,organ_code -- 内部机构编号
            ,fun_organ -- 职能机构
            ,fun_dep -- 职能部门
            ,zoneno -- 分行号
            ,p_bo_c_financial_code -- 人民银行金融机构编号
            ,financial_code -- 金融机构标识码
            ,s_w_i_f_t_code -- swift号码
            ,bank_code -- 支付系统银行行号
            ,legal -- 法人号
            ,business_license -- 营业执照号码
            ,organization_code -- 组织机构代码
            ,tax_id -- 税务登记证号
            ,organ_cn_full_name -- 组织机构名称
            ,organ_cn_short_name -- 组织机构简称
            ,organ_en_full_name -- 组织机构英文全称
            ,organ_en_short_name -- 组织机构英文简称
            ,organ_state_code -- 机构营业状态
            ,organ_status -- 机构状态
            ,organ_founding_date -- 机构成立日期
            ,organ_close_date -- 机构关闭日期
            ,organ_type -- 组织机构类型
            ,is_st -- 是否为实体机构
            ,is_hs -- 是否为核算机构
            ,is_yy -- 是否为营业机构
            ,is_xz -- 是否为行政机构
            ,is_zw -- 是否为账务机构
            ,organ_level -- 组织机构级别代码
            ,leaf_note_flag -- 叶节点标志
            ,xzup_organ_code -- 行政上级组织机构编码
            ,zwup_organ_code -- 账务上级组织机构编码
            ,hsup_organ_code -- 核算上级组织机构编码
            ,seque -- 机构顺序号
            ,post_code -- 邮政编码
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 所在县/区
            ,address -- 详细地址
            ,email -- 电子邮箱
            ,u_r_l -- 网址
            ,country_code -- 国际长途区号
            ,area_code -- 国内长途区号
            ,phone -- 电话号码
            ,sub_phone -- 分机号
            ,service_phone -- 服务电话
            ,financial_lic_num -- 金融许可证号码
            ,organ_system -- 机构关联系统
            ,last_updated_stamp -- bosent自带最后修改时间
            ,last_updated_tx_stamp -- bosent自带最后修改时间
            ,created_stamp -- bosent自带创建时间
            ,created_tx_stamp -- bosent自带创建时间
            ,orderno -- 显示顺序号
            ,cbrcfininstt_id -- 银监会金融机构编号
            ,union_financial_code -- 银联金融机构编号
            ,isxnhs -- 是否为虚拟核算机构   入职需要
            ,head_emply_id -- 机构类型为核算时，校验为必输
            ,is_business_division -- 是否为事业部
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_common_orgcode_op(
            organ_code_key -- 机构唯一标识
            ,organ_code -- 内部机构编号
            ,fun_organ -- 职能机构
            ,fun_dep -- 职能部门
            ,zoneno -- 分行号
            ,p_bo_c_financial_code -- 人民银行金融机构编号
            ,financial_code -- 金融机构标识码
            ,s_w_i_f_t_code -- swift号码
            ,bank_code -- 支付系统银行行号
            ,legal -- 法人号
            ,business_license -- 营业执照号码
            ,organization_code -- 组织机构代码
            ,tax_id -- 税务登记证号
            ,organ_cn_full_name -- 组织机构名称
            ,organ_cn_short_name -- 组织机构简称
            ,organ_en_full_name -- 组织机构英文全称
            ,organ_en_short_name -- 组织机构英文简称
            ,organ_state_code -- 机构营业状态
            ,organ_status -- 机构状态
            ,organ_founding_date -- 机构成立日期
            ,organ_close_date -- 机构关闭日期
            ,organ_type -- 组织机构类型
            ,is_st -- 是否为实体机构
            ,is_hs -- 是否为核算机构
            ,is_yy -- 是否为营业机构
            ,is_xz -- 是否为行政机构
            ,is_zw -- 是否为账务机构
            ,organ_level -- 组织机构级别代码
            ,leaf_note_flag -- 叶节点标志
            ,xzup_organ_code -- 行政上级组织机构编码
            ,zwup_organ_code -- 账务上级组织机构编码
            ,hsup_organ_code -- 核算上级组织机构编码
            ,seque -- 机构顺序号
            ,post_code -- 邮政编码
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 所在县/区
            ,address -- 详细地址
            ,email -- 电子邮箱
            ,u_r_l -- 网址
            ,country_code -- 国际长途区号
            ,area_code -- 国内长途区号
            ,phone -- 电话号码
            ,sub_phone -- 分机号
            ,service_phone -- 服务电话
            ,financial_lic_num -- 金融许可证号码
            ,organ_system -- 机构关联系统
            ,last_updated_stamp -- bosent自带最后修改时间
            ,last_updated_tx_stamp -- bosent自带最后修改时间
            ,created_stamp -- bosent自带创建时间
            ,created_tx_stamp -- bosent自带创建时间
            ,orderno -- 显示顺序号
            ,cbrcfininstt_id -- 银监会金融机构编号
            ,union_financial_code -- 银联金融机构编号
            ,isxnhs -- 是否为虚拟核算机构   入职需要
            ,head_emply_id -- 机构类型为核算时，校验为必输
            ,is_business_division -- 是否为事业部
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.organ_code_key -- 机构唯一标识
    ,o.organ_code -- 内部机构编号
    ,o.fun_organ -- 职能机构
    ,o.fun_dep -- 职能部门
    ,o.zoneno -- 分行号
    ,o.p_bo_c_financial_code -- 人民银行金融机构编号
    ,o.financial_code -- 金融机构标识码
    ,o.s_w_i_f_t_code -- swift号码
    ,o.bank_code -- 支付系统银行行号
    ,o.legal -- 法人号
    ,o.business_license -- 营业执照号码
    ,o.organization_code -- 组织机构代码
    ,o.tax_id -- 税务登记证号
    ,o.organ_cn_full_name -- 组织机构名称
    ,o.organ_cn_short_name -- 组织机构简称
    ,o.organ_en_full_name -- 组织机构英文全称
    ,o.organ_en_short_name -- 组织机构英文简称
    ,o.organ_state_code -- 机构营业状态
    ,o.organ_status -- 机构状态
    ,o.organ_founding_date -- 机构成立日期
    ,o.organ_close_date -- 机构关闭日期
    ,o.organ_type -- 组织机构类型
    ,o.is_st -- 是否为实体机构
    ,o.is_hs -- 是否为核算机构
    ,o.is_yy -- 是否为营业机构
    ,o.is_xz -- 是否为行政机构
    ,o.is_zw -- 是否为账务机构
    ,o.organ_level -- 组织机构级别代码
    ,o.leaf_note_flag -- 叶节点标志
    ,o.xzup_organ_code -- 行政上级组织机构编码
    ,o.zwup_organ_code -- 账务上级组织机构编码
    ,o.hsup_organ_code -- 核算上级组织机构编码
    ,o.seque -- 机构顺序号
    ,o.post_code -- 邮政编码
    ,o.country -- 所在国家
    ,o.province -- 所在省/州
    ,o.city -- 所在城市
    ,o.county -- 所在县/区
    ,o.address -- 详细地址
    ,o.email -- 电子邮箱
    ,o.u_r_l -- 网址
    ,o.country_code -- 国际长途区号
    ,o.area_code -- 国内长途区号
    ,o.phone -- 电话号码
    ,o.sub_phone -- 分机号
    ,o.service_phone -- 服务电话
    ,o.financial_lic_num -- 金融许可证号码
    ,o.organ_system -- 机构关联系统
    ,o.last_updated_stamp -- bosent自带最后修改时间
    ,o.last_updated_tx_stamp -- bosent自带最后修改时间
    ,o.created_stamp -- bosent自带创建时间
    ,o.created_tx_stamp -- bosent自带创建时间
    ,o.orderno -- 显示顺序号
    ,o.cbrcfininstt_id -- 银监会金融机构编号
    ,o.union_financial_code -- 银联金融机构编号
    ,o.isxnhs -- 是否为虚拟核算机构   入职需要
    ,o.head_emply_id -- 机构类型为核算时，校验为必输
    ,o.is_business_division -- 是否为事业部
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
from ${iol_schema}.noas_common_orgcode_bk o
    left join ${iol_schema}.noas_common_orgcode_op n
        on
            o.organ_code = n.organ_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.noas_common_orgcode_cl d
        on
            o.organ_code = d.organ_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.noas_common_orgcode;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('noas_common_orgcode') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.noas_common_orgcode drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.noas_common_orgcode add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.noas_common_orgcode exchange partition p_${batch_date} with table ${iol_schema}.noas_common_orgcode_cl;
alter table ${iol_schema}.noas_common_orgcode exchange partition p_20991231 with table ${iol_schema}.noas_common_orgcode_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.noas_common_orgcode to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_common_orgcode_op purge;
drop table ${iol_schema}.noas_common_orgcode_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.noas_common_orgcode_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'noas_common_orgcode',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
