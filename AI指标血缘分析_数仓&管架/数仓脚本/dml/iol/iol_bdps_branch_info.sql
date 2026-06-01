/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_branch_info
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
create table ${iol_schema}.bdps_branch_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_branch_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_branch_info_op purge;
drop table ${iol_schema}.bdps_branch_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_branch_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_branch_info where 0=1;

create table ${iol_schema}.bdps_branch_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_branch_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_branch_info_cl(
            id -- ID
            ,brh_no -- 行号
            ,brh_name -- 行名
            ,brh_class -- 机构级别
            ,bln_up_brh_id -- 管辖机构
            ,tele_no -- 联系电话
            ,address -- 地址
            ,postno -- 邮编
            ,status -- 状态
            ,effect_date -- 生效日期
            ,expire_date -- 失效日期
            ,bln_brh_no -- 分行号
            ,ubank_no -- 联行号
            ,acct_brh_id -- 记账机构ID
            ,bop_financ_org_code -- 人民银行金融机构编号
            ,last_upd_oper_id -- 最后修改操作员号
            ,last_upd_time -- 最后修改时间
            ,dualcontrol_lockstatuscert -- 双岗复核锁标记
            ,dualcontrol_lockstatus -- 
            ,brcode -- 支行号
            ,manager -- 负责人
            ,misc -- 备注
            ,brh_full_name -- 机构全称
            ,belong_brh_id_opt -- 撤并机构id
            ,organcodekey -- 机构唯一标识
            ,funorgan -- 职能机构
            ,fundep -- 职能部门
            ,financialcode -- 金融机构标识码
            ,swiftcode -- SWIFT号码
            ,bankcode -- 支付系统银行行号
            ,businesslicense -- 营业执照号码
            ,organizationcode -- 内部机构代码
            ,taxid -- 税务登记证号
            ,organenfullname -- 内部机构英文全称
            ,organenshortname -- 内部机构英文简称
            ,organstatecode -- 机构营业状态代码
            ,organtype -- 内部机构类型代码
            ,isst -- 实体机构标志
            ,ishs -- 核算机构标志
            ,isyy -- 营业机构标志
            ,isxz -- 行政机构标志
            ,iszw -- 账务机构标志
            ,leafnoteflag -- 叶节点标志
            ,zwuporgancode -- 账务上级内部机构编码
            ,hsuporgancode -- 核算上级内部机构编码
            ,seque -- 机构顺序号
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 所在县/区
            ,email -- 电子邮箱
            ,url -- 网址
            ,countrycode -- 国际长途区号
            ,areacode -- 国内长途区号
            ,subphone -- 分机号
            ,servicephone -- 服务电话
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_branch_info_op(
            id -- ID
            ,brh_no -- 行号
            ,brh_name -- 行名
            ,brh_class -- 机构级别
            ,bln_up_brh_id -- 管辖机构
            ,tele_no -- 联系电话
            ,address -- 地址
            ,postno -- 邮编
            ,status -- 状态
            ,effect_date -- 生效日期
            ,expire_date -- 失效日期
            ,bln_brh_no -- 分行号
            ,ubank_no -- 联行号
            ,acct_brh_id -- 记账机构ID
            ,bop_financ_org_code -- 人民银行金融机构编号
            ,last_upd_oper_id -- 最后修改操作员号
            ,last_upd_time -- 最后修改时间
            ,dualcontrol_lockstatuscert -- 双岗复核锁标记
            ,dualcontrol_lockstatus -- 
            ,brcode -- 支行号
            ,manager -- 负责人
            ,misc -- 备注
            ,brh_full_name -- 机构全称
            ,belong_brh_id_opt -- 撤并机构id
            ,organcodekey -- 机构唯一标识
            ,funorgan -- 职能机构
            ,fundep -- 职能部门
            ,financialcode -- 金融机构标识码
            ,swiftcode -- SWIFT号码
            ,bankcode -- 支付系统银行行号
            ,businesslicense -- 营业执照号码
            ,organizationcode -- 内部机构代码
            ,taxid -- 税务登记证号
            ,organenfullname -- 内部机构英文全称
            ,organenshortname -- 内部机构英文简称
            ,organstatecode -- 机构营业状态代码
            ,organtype -- 内部机构类型代码
            ,isst -- 实体机构标志
            ,ishs -- 核算机构标志
            ,isyy -- 营业机构标志
            ,isxz -- 行政机构标志
            ,iszw -- 账务机构标志
            ,leafnoteflag -- 叶节点标志
            ,zwuporgancode -- 账务上级内部机构编码
            ,hsuporgancode -- 核算上级内部机构编码
            ,seque -- 机构顺序号
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 所在县/区
            ,email -- 电子邮箱
            ,url -- 网址
            ,countrycode -- 国际长途区号
            ,areacode -- 国内长途区号
            ,subphone -- 分机号
            ,servicephone -- 服务电话
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.brh_no, o.brh_no) as brh_no -- 行号
    ,nvl(n.brh_name, o.brh_name) as brh_name -- 行名
    ,nvl(n.brh_class, o.brh_class) as brh_class -- 机构级别
    ,nvl(n.bln_up_brh_id, o.bln_up_brh_id) as bln_up_brh_id -- 管辖机构
    ,nvl(n.tele_no, o.tele_no) as tele_no -- 联系电话
    ,nvl(n.address, o.address) as address -- 地址
    ,nvl(n.postno, o.postno) as postno -- 邮编
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 生效日期
    ,nvl(n.expire_date, o.expire_date) as expire_date -- 失效日期
    ,nvl(n.bln_brh_no, o.bln_brh_no) as bln_brh_no -- 分行号
    ,nvl(n.ubank_no, o.ubank_no) as ubank_no -- 联行号
    ,nvl(n.acct_brh_id, o.acct_brh_id) as acct_brh_id -- 记账机构ID
    ,nvl(n.bop_financ_org_code, o.bop_financ_org_code) as bop_financ_org_code -- 人民银行金融机构编号
    ,nvl(n.last_upd_oper_id, o.last_upd_oper_id) as last_upd_oper_id -- 最后修改操作员号
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.dualcontrol_lockstatuscert, o.dualcontrol_lockstatuscert) as dualcontrol_lockstatuscert -- 双岗复核锁标记
    ,nvl(n.dualcontrol_lockstatus, o.dualcontrol_lockstatus) as dualcontrol_lockstatus -- 
    ,nvl(n.brcode, o.brcode) as brcode -- 支行号
    ,nvl(n.manager, o.manager) as manager -- 负责人
    ,nvl(n.misc, o.misc) as misc -- 备注
    ,nvl(n.brh_full_name, o.brh_full_name) as brh_full_name -- 机构全称
    ,nvl(n.belong_brh_id_opt, o.belong_brh_id_opt) as belong_brh_id_opt -- 撤并机构id
    ,nvl(n.organcodekey, o.organcodekey) as organcodekey -- 机构唯一标识
    ,nvl(n.funorgan, o.funorgan) as funorgan -- 职能机构
    ,nvl(n.fundep, o.fundep) as fundep -- 职能部门
    ,nvl(n.financialcode, o.financialcode) as financialcode -- 金融机构标识码
    ,nvl(n.swiftcode, o.swiftcode) as swiftcode -- SWIFT号码
    ,nvl(n.bankcode, o.bankcode) as bankcode -- 支付系统银行行号
    ,nvl(n.businesslicense, o.businesslicense) as businesslicense -- 营业执照号码
    ,nvl(n.organizationcode, o.organizationcode) as organizationcode -- 内部机构代码
    ,nvl(n.taxid, o.taxid) as taxid -- 税务登记证号
    ,nvl(n.organenfullname, o.organenfullname) as organenfullname -- 内部机构英文全称
    ,nvl(n.organenshortname, o.organenshortname) as organenshortname -- 内部机构英文简称
    ,nvl(n.organstatecode, o.organstatecode) as organstatecode -- 机构营业状态代码
    ,nvl(n.organtype, o.organtype) as organtype -- 内部机构类型代码
    ,nvl(n.isst, o.isst) as isst -- 实体机构标志
    ,nvl(n.ishs, o.ishs) as ishs -- 核算机构标志
    ,nvl(n.isyy, o.isyy) as isyy -- 营业机构标志
    ,nvl(n.isxz, o.isxz) as isxz -- 行政机构标志
    ,nvl(n.iszw, o.iszw) as iszw -- 账务机构标志
    ,nvl(n.leafnoteflag, o.leafnoteflag) as leafnoteflag -- 叶节点标志
    ,nvl(n.zwuporgancode, o.zwuporgancode) as zwuporgancode -- 账务上级内部机构编码
    ,nvl(n.hsuporgancode, o.hsuporgancode) as hsuporgancode -- 核算上级内部机构编码
    ,nvl(n.seque, o.seque) as seque -- 机构顺序号
    ,nvl(n.country, o.country) as country -- 所在国家
    ,nvl(n.province, o.province) as province -- 所在省/州
    ,nvl(n.city, o.city) as city -- 所在城市
    ,nvl(n.county, o.county) as county -- 所在县/区
    ,nvl(n.email, o.email) as email -- 电子邮箱
    ,nvl(n.url, o.url) as url -- 网址
    ,nvl(n.countrycode, o.countrycode) as countrycode -- 国际长途区号
    ,nvl(n.areacode, o.areacode) as areacode -- 国内长途区号
    ,nvl(n.subphone, o.subphone) as subphone -- 分机号
    ,nvl(n.servicephone, o.servicephone) as servicephone -- 服务电话
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
from (select * from ${iol_schema}.bdps_branch_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_branch_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.brh_no <> n.brh_no
        or o.brh_name <> n.brh_name
        or o.brh_class <> n.brh_class
        or o.bln_up_brh_id <> n.bln_up_brh_id
        or o.tele_no <> n.tele_no
        or o.address <> n.address
        or o.postno <> n.postno
        or o.status <> n.status
        or o.effect_date <> n.effect_date
        or o.expire_date <> n.expire_date
        or o.bln_brh_no <> n.bln_brh_no
        or o.ubank_no <> n.ubank_no
        or o.acct_brh_id <> n.acct_brh_id
        or o.bop_financ_org_code <> n.bop_financ_org_code
        or o.last_upd_oper_id <> n.last_upd_oper_id
        or o.last_upd_time <> n.last_upd_time
        or o.dualcontrol_lockstatuscert <> n.dualcontrol_lockstatuscert
        or o.dualcontrol_lockstatus <> n.dualcontrol_lockstatus
        or o.brcode <> n.brcode
        or o.manager <> n.manager
        or o.misc <> n.misc
        or o.brh_full_name <> n.brh_full_name
        or o.belong_brh_id_opt <> n.belong_brh_id_opt
        or o.organcodekey <> n.organcodekey
        or o.funorgan <> n.funorgan
        or o.fundep <> n.fundep
        or o.financialcode <> n.financialcode
        or o.swiftcode <> n.swiftcode
        or o.bankcode <> n.bankcode
        or o.businesslicense <> n.businesslicense
        or o.organizationcode <> n.organizationcode
        or o.taxid <> n.taxid
        or o.organenfullname <> n.organenfullname
        or o.organenshortname <> n.organenshortname
        or o.organstatecode <> n.organstatecode
        or o.organtype <> n.organtype
        or o.isst <> n.isst
        or o.ishs <> n.ishs
        or o.isyy <> n.isyy
        or o.isxz <> n.isxz
        or o.iszw <> n.iszw
        or o.leafnoteflag <> n.leafnoteflag
        or o.zwuporgancode <> n.zwuporgancode
        or o.hsuporgancode <> n.hsuporgancode
        or o.seque <> n.seque
        or o.country <> n.country
        or o.province <> n.province
        or o.city <> n.city
        or o.county <> n.county
        or o.email <> n.email
        or o.url <> n.url
        or o.countrycode <> n.countrycode
        or o.areacode <> n.areacode
        or o.subphone <> n.subphone
        or o.servicephone <> n.servicephone
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_branch_info_cl(
            id -- ID
            ,brh_no -- 行号
            ,brh_name -- 行名
            ,brh_class -- 机构级别
            ,bln_up_brh_id -- 管辖机构
            ,tele_no -- 联系电话
            ,address -- 地址
            ,postno -- 邮编
            ,status -- 状态
            ,effect_date -- 生效日期
            ,expire_date -- 失效日期
            ,bln_brh_no -- 分行号
            ,ubank_no -- 联行号
            ,acct_brh_id -- 记账机构ID
            ,bop_financ_org_code -- 人民银行金融机构编号
            ,last_upd_oper_id -- 最后修改操作员号
            ,last_upd_time -- 最后修改时间
            ,dualcontrol_lockstatuscert -- 双岗复核锁标记
            ,dualcontrol_lockstatus -- 
            ,brcode -- 支行号
            ,manager -- 负责人
            ,misc -- 备注
            ,brh_full_name -- 机构全称
            ,belong_brh_id_opt -- 撤并机构id
            ,organcodekey -- 机构唯一标识
            ,funorgan -- 职能机构
            ,fundep -- 职能部门
            ,financialcode -- 金融机构标识码
            ,swiftcode -- SWIFT号码
            ,bankcode -- 支付系统银行行号
            ,businesslicense -- 营业执照号码
            ,organizationcode -- 内部机构代码
            ,taxid -- 税务登记证号
            ,organenfullname -- 内部机构英文全称
            ,organenshortname -- 内部机构英文简称
            ,organstatecode -- 机构营业状态代码
            ,organtype -- 内部机构类型代码
            ,isst -- 实体机构标志
            ,ishs -- 核算机构标志
            ,isyy -- 营业机构标志
            ,isxz -- 行政机构标志
            ,iszw -- 账务机构标志
            ,leafnoteflag -- 叶节点标志
            ,zwuporgancode -- 账务上级内部机构编码
            ,hsuporgancode -- 核算上级内部机构编码
            ,seque -- 机构顺序号
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 所在县/区
            ,email -- 电子邮箱
            ,url -- 网址
            ,countrycode -- 国际长途区号
            ,areacode -- 国内长途区号
            ,subphone -- 分机号
            ,servicephone -- 服务电话
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_branch_info_op(
            id -- ID
            ,brh_no -- 行号
            ,brh_name -- 行名
            ,brh_class -- 机构级别
            ,bln_up_brh_id -- 管辖机构
            ,tele_no -- 联系电话
            ,address -- 地址
            ,postno -- 邮编
            ,status -- 状态
            ,effect_date -- 生效日期
            ,expire_date -- 失效日期
            ,bln_brh_no -- 分行号
            ,ubank_no -- 联行号
            ,acct_brh_id -- 记账机构ID
            ,bop_financ_org_code -- 人民银行金融机构编号
            ,last_upd_oper_id -- 最后修改操作员号
            ,last_upd_time -- 最后修改时间
            ,dualcontrol_lockstatuscert -- 双岗复核锁标记
            ,dualcontrol_lockstatus -- 
            ,brcode -- 支行号
            ,manager -- 负责人
            ,misc -- 备注
            ,brh_full_name -- 机构全称
            ,belong_brh_id_opt -- 撤并机构id
            ,organcodekey -- 机构唯一标识
            ,funorgan -- 职能机构
            ,fundep -- 职能部门
            ,financialcode -- 金融机构标识码
            ,swiftcode -- SWIFT号码
            ,bankcode -- 支付系统银行行号
            ,businesslicense -- 营业执照号码
            ,organizationcode -- 内部机构代码
            ,taxid -- 税务登记证号
            ,organenfullname -- 内部机构英文全称
            ,organenshortname -- 内部机构英文简称
            ,organstatecode -- 机构营业状态代码
            ,organtype -- 内部机构类型代码
            ,isst -- 实体机构标志
            ,ishs -- 核算机构标志
            ,isyy -- 营业机构标志
            ,isxz -- 行政机构标志
            ,iszw -- 账务机构标志
            ,leafnoteflag -- 叶节点标志
            ,zwuporgancode -- 账务上级内部机构编码
            ,hsuporgancode -- 核算上级内部机构编码
            ,seque -- 机构顺序号
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 所在县/区
            ,email -- 电子邮箱
            ,url -- 网址
            ,countrycode -- 国际长途区号
            ,areacode -- 国内长途区号
            ,subphone -- 分机号
            ,servicephone -- 服务电话
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.brh_no -- 行号
    ,o.brh_name -- 行名
    ,o.brh_class -- 机构级别
    ,o.bln_up_brh_id -- 管辖机构
    ,o.tele_no -- 联系电话
    ,o.address -- 地址
    ,o.postno -- 邮编
    ,o.status -- 状态
    ,o.effect_date -- 生效日期
    ,o.expire_date -- 失效日期
    ,o.bln_brh_no -- 分行号
    ,o.ubank_no -- 联行号
    ,o.acct_brh_id -- 记账机构ID
    ,o.bop_financ_org_code -- 人民银行金融机构编号
    ,o.last_upd_oper_id -- 最后修改操作员号
    ,o.last_upd_time -- 最后修改时间
    ,o.dualcontrol_lockstatuscert -- 双岗复核锁标记
    ,o.dualcontrol_lockstatus -- 
    ,o.brcode -- 支行号
    ,o.manager -- 负责人
    ,o.misc -- 备注
    ,o.brh_full_name -- 机构全称
    ,o.belong_brh_id_opt -- 撤并机构id
    ,o.organcodekey -- 机构唯一标识
    ,o.funorgan -- 职能机构
    ,o.fundep -- 职能部门
    ,o.financialcode -- 金融机构标识码
    ,o.swiftcode -- SWIFT号码
    ,o.bankcode -- 支付系统银行行号
    ,o.businesslicense -- 营业执照号码
    ,o.organizationcode -- 内部机构代码
    ,o.taxid -- 税务登记证号
    ,o.organenfullname -- 内部机构英文全称
    ,o.organenshortname -- 内部机构英文简称
    ,o.organstatecode -- 机构营业状态代码
    ,o.organtype -- 内部机构类型代码
    ,o.isst -- 实体机构标志
    ,o.ishs -- 核算机构标志
    ,o.isyy -- 营业机构标志
    ,o.isxz -- 行政机构标志
    ,o.iszw -- 账务机构标志
    ,o.leafnoteflag -- 叶节点标志
    ,o.zwuporgancode -- 账务上级内部机构编码
    ,o.hsuporgancode -- 核算上级内部机构编码
    ,o.seque -- 机构顺序号
    ,o.country -- 所在国家
    ,o.province -- 所在省/州
    ,o.city -- 所在城市
    ,o.county -- 所在县/区
    ,o.email -- 电子邮箱
    ,o.url -- 网址
    ,o.countrycode -- 国际长途区号
    ,o.areacode -- 国内长途区号
    ,o.subphone -- 分机号
    ,o.servicephone -- 服务电话
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
from ${iol_schema}.bdps_branch_info_bk o
    left join ${iol_schema}.bdps_branch_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_branch_info_cl d
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
--truncate table ${iol_schema}.bdps_branch_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdps_branch_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdps_branch_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdps_branch_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdps_branch_info exchange partition p_${batch_date} with table ${iol_schema}.bdps_branch_info_cl;
alter table ${iol_schema}.bdps_branch_info exchange partition p_20991231 with table ${iol_schema}.bdps_branch_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_branch_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_branch_info_op purge;
drop table ${iol_schema}.bdps_branch_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_branch_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_branch_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
