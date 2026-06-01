/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_org_info
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
create table ${iol_schema}.icms_org_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_org_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_org_info_op purge;
drop table ${iol_schema}.icms_org_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_org_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_org_info where 0=1;

create table ${iol_schema}.icms_org_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_org_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_org_info_cl(
            orgid -- 机构编号
            ,orgstatus -- 机构状态
            ,orgadd -- 机构地址
            ,cmnum -- 客户经理数
            ,hostno -- 主机号
            ,corporgid -- 法人机构编号
            ,vitualid -- 虚拟柜员号
            ,inputuser -- 登记人
            ,updatedate -- 
            ,orglevel -- 机构级别
            ,orgclass -- 机构类型
            ,orgcode -- 机构编码
            ,updateuser -- 更新人
            ,orgproperty -- 属性集
            ,relativeorgid -- 上级机构编号
            ,orgtel -- 联系电话
            ,businesslicense -- 营业执照机构级别
            ,branchnum -- 管辖网点数
            ,updatetime -- 更新时间
            ,belongarea -- 行政区划
            ,zipcode -- 邮政编码
            ,principal -- 负责人
            ,belongorgid -- 权属机构
            ,inputorg -- 登记机构
            ,orgoldname -- 机构曾用名
            ,setupdate -- 机构成立日期
            ,businesshours -- 营业时间
            ,updateorg -- 更新机构
            ,inputtime -- 登记时间
            ,inputdate -- 
            ,banklicense -- 金融许可证编号
            ,mainframeexgid -- 交换号
            ,ishs -- 是否是记账机构,码值：YesNo
            ,orgname -- 机构名称
            ,remark -- 备注
            ,vitualserialno -- 虚拟流水号
            ,bankid -- 人行金融机构编码
            ,sortno -- 排序号
            ,mainframeorgid -- 网点号
            ,title -- 职务
            ,fixphone -- 传真
            ,contactpeople -- 联系人
            ,mobiletel -- 联系人手机号码
            ,email -- 电子邮箱
            ,orgalias -- 机构批复简称
            ,belongorglevel -- 上级机构层级
            ,icmsorglevel -- 信贷机构层级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_org_info_op(
            orgid -- 机构编号
            ,orgstatus -- 机构状态
            ,orgadd -- 机构地址
            ,cmnum -- 客户经理数
            ,hostno -- 主机号
            ,corporgid -- 法人机构编号
            ,vitualid -- 虚拟柜员号
            ,inputuser -- 登记人
            ,updatedate -- 
            ,orglevel -- 机构级别
            ,orgclass -- 机构类型
            ,orgcode -- 机构编码
            ,updateuser -- 更新人
            ,orgproperty -- 属性集
            ,relativeorgid -- 上级机构编号
            ,orgtel -- 联系电话
            ,businesslicense -- 营业执照机构级别
            ,branchnum -- 管辖网点数
            ,updatetime -- 更新时间
            ,belongarea -- 行政区划
            ,zipcode -- 邮政编码
            ,principal -- 负责人
            ,belongorgid -- 权属机构
            ,inputorg -- 登记机构
            ,orgoldname -- 机构曾用名
            ,setupdate -- 机构成立日期
            ,businesshours -- 营业时间
            ,updateorg -- 更新机构
            ,inputtime -- 登记时间
            ,inputdate -- 
            ,banklicense -- 金融许可证编号
            ,mainframeexgid -- 交换号
            ,ishs -- 是否是记账机构,码值：YesNo
            ,orgname -- 机构名称
            ,remark -- 备注
            ,vitualserialno -- 虚拟流水号
            ,bankid -- 人行金融机构编码
            ,sortno -- 排序号
            ,mainframeorgid -- 网点号
            ,title -- 职务
            ,fixphone -- 传真
            ,contactpeople -- 联系人
            ,mobiletel -- 联系人手机号码
            ,email -- 电子邮箱
            ,orgalias -- 机构批复简称
            ,belongorglevel -- 上级机构层级
            ,icmsorglevel -- 信贷机构层级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.orgid, o.orgid) as orgid -- 机构编号
    ,nvl(n.orgstatus, o.orgstatus) as orgstatus -- 机构状态
    ,nvl(n.orgadd, o.orgadd) as orgadd -- 机构地址
    ,nvl(n.cmnum, o.cmnum) as cmnum -- 客户经理数
    ,nvl(n.hostno, o.hostno) as hostno -- 主机号
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.vitualid, o.vitualid) as vitualid -- 虚拟柜员号
    ,nvl(n.inputuser, o.inputuser) as inputuser -- 登记人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 
    ,nvl(n.orglevel, o.orglevel) as orglevel -- 机构级别
    ,nvl(n.orgclass, o.orgclass) as orgclass -- 机构类型
    ,nvl(n.orgcode, o.orgcode) as orgcode -- 机构编码
    ,nvl(n.updateuser, o.updateuser) as updateuser -- 更新人
    ,nvl(n.orgproperty, o.orgproperty) as orgproperty -- 属性集
    ,nvl(n.relativeorgid, o.relativeorgid) as relativeorgid -- 上级机构编号
    ,nvl(n.orgtel, o.orgtel) as orgtel -- 联系电话
    ,nvl(n.businesslicense, o.businesslicense) as businesslicense -- 营业执照机构级别
    ,nvl(n.branchnum, o.branchnum) as branchnum -- 管辖网点数
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.belongarea, o.belongarea) as belongarea -- 行政区划
    ,nvl(n.zipcode, o.zipcode) as zipcode -- 邮政编码
    ,nvl(n.principal, o.principal) as principal -- 负责人
    ,nvl(n.belongorgid, o.belongorgid) as belongorgid -- 权属机构
    ,nvl(n.inputorg, o.inputorg) as inputorg -- 登记机构
    ,nvl(n.orgoldname, o.orgoldname) as orgoldname -- 机构曾用名
    ,nvl(n.setupdate, o.setupdate) as setupdate -- 机构成立日期
    ,nvl(n.businesshours, o.businesshours) as businesshours -- 营业时间
    ,nvl(n.updateorg, o.updateorg) as updateorg -- 更新机构
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 登记时间
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 
    ,nvl(n.banklicense, o.banklicense) as banklicense -- 金融许可证编号
    ,nvl(n.mainframeexgid, o.mainframeexgid) as mainframeexgid -- 交换号
    ,nvl(n.ishs, o.ishs) as ishs -- 是否是记账机构,码值：YesNo
    ,nvl(n.orgname, o.orgname) as orgname -- 机构名称
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.vitualserialno, o.vitualserialno) as vitualserialno -- 虚拟流水号
    ,nvl(n.bankid, o.bankid) as bankid -- 人行金融机构编码
    ,nvl(n.sortno, o.sortno) as sortno -- 排序号
    ,nvl(n.mainframeorgid, o.mainframeorgid) as mainframeorgid -- 网点号
    ,nvl(n.title, o.title) as title -- 职务
    ,nvl(n.fixphone, o.fixphone) as fixphone -- 传真
    ,nvl(n.contactpeople, o.contactpeople) as contactpeople -- 联系人
    ,nvl(n.mobiletel, o.mobiletel) as mobiletel -- 联系人手机号码
    ,nvl(n.email, o.email) as email -- 电子邮箱
    ,nvl(n.orgalias, o.orgalias) as orgalias -- 机构批复简称
    ,nvl(n.belongorglevel, o.belongorglevel) as belongorglevel -- 上级机构层级
    ,nvl(n.icmsorglevel, o.icmsorglevel) as icmsorglevel -- 信贷机构层级
    ,case when
            n.orgid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.orgid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.orgid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_org_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_org_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.orgid = n.orgid
where (
        o.orgid is null
    )
    or (
        n.orgid is null
    )
    or (
        o.orgstatus <> n.orgstatus
        or o.orgadd <> n.orgadd
        or o.cmnum <> n.cmnum
        or o.hostno <> n.hostno
        or o.corporgid <> n.corporgid
        or o.vitualid <> n.vitualid
        or o.inputuser <> n.inputuser
        or o.updatedate <> n.updatedate
        or o.orglevel <> n.orglevel
        or o.orgclass <> n.orgclass
        or o.orgcode <> n.orgcode
        or o.updateuser <> n.updateuser
        or o.orgproperty <> n.orgproperty
        or o.relativeorgid <> n.relativeorgid
        or o.orgtel <> n.orgtel
        or o.businesslicense <> n.businesslicense
        or o.branchnum <> n.branchnum
        or o.updatetime <> n.updatetime
        or o.belongarea <> n.belongarea
        or o.zipcode <> n.zipcode
        or o.principal <> n.principal
        or o.belongorgid <> n.belongorgid
        or o.inputorg <> n.inputorg
        or o.orgoldname <> n.orgoldname
        or o.setupdate <> n.setupdate
        or o.businesshours <> n.businesshours
        or o.updateorg <> n.updateorg
        or o.inputtime <> n.inputtime
        or o.inputdate <> n.inputdate
        or o.banklicense <> n.banklicense
        or o.mainframeexgid <> n.mainframeexgid
        or o.ishs <> n.ishs
        or o.orgname <> n.orgname
        or o.remark <> n.remark
        or o.vitualserialno <> n.vitualserialno
        or o.bankid <> n.bankid
        or o.sortno <> n.sortno
        or o.mainframeorgid <> n.mainframeorgid
        or o.title <> n.title
        or o.fixphone <> n.fixphone
        or o.contactpeople <> n.contactpeople
        or o.mobiletel <> n.mobiletel
        or o.email <> n.email
        or o.orgalias <> n.orgalias
        or o.belongorglevel <> n.belongorglevel
        or o.icmsorglevel <> n.icmsorglevel
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_org_info_cl(
            orgid -- 机构编号
            ,orgstatus -- 机构状态
            ,orgadd -- 机构地址
            ,cmnum -- 客户经理数
            ,hostno -- 主机号
            ,corporgid -- 法人机构编号
            ,vitualid -- 虚拟柜员号
            ,inputuser -- 登记人
            ,updatedate -- 
            ,orglevel -- 机构级别
            ,orgclass -- 机构类型
            ,orgcode -- 机构编码
            ,updateuser -- 更新人
            ,orgproperty -- 属性集
            ,relativeorgid -- 上级机构编号
            ,orgtel -- 联系电话
            ,businesslicense -- 营业执照机构级别
            ,branchnum -- 管辖网点数
            ,updatetime -- 更新时间
            ,belongarea -- 行政区划
            ,zipcode -- 邮政编码
            ,principal -- 负责人
            ,belongorgid -- 权属机构
            ,inputorg -- 登记机构
            ,orgoldname -- 机构曾用名
            ,setupdate -- 机构成立日期
            ,businesshours -- 营业时间
            ,updateorg -- 更新机构
            ,inputtime -- 登记时间
            ,inputdate -- 
            ,banklicense -- 金融许可证编号
            ,mainframeexgid -- 交换号
            ,ishs -- 是否是记账机构,码值：YesNo
            ,orgname -- 机构名称
            ,remark -- 备注
            ,vitualserialno -- 虚拟流水号
            ,bankid -- 人行金融机构编码
            ,sortno -- 排序号
            ,mainframeorgid -- 网点号
            ,title -- 职务
            ,fixphone -- 传真
            ,contactpeople -- 联系人
            ,mobiletel -- 联系人手机号码
            ,email -- 电子邮箱
            ,orgalias -- 机构批复简称
            ,belongorglevel -- 上级机构层级
            ,icmsorglevel -- 信贷机构层级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_org_info_op(
            orgid -- 机构编号
            ,orgstatus -- 机构状态
            ,orgadd -- 机构地址
            ,cmnum -- 客户经理数
            ,hostno -- 主机号
            ,corporgid -- 法人机构编号
            ,vitualid -- 虚拟柜员号
            ,inputuser -- 登记人
            ,updatedate -- 
            ,orglevel -- 机构级别
            ,orgclass -- 机构类型
            ,orgcode -- 机构编码
            ,updateuser -- 更新人
            ,orgproperty -- 属性集
            ,relativeorgid -- 上级机构编号
            ,orgtel -- 联系电话
            ,businesslicense -- 营业执照机构级别
            ,branchnum -- 管辖网点数
            ,updatetime -- 更新时间
            ,belongarea -- 行政区划
            ,zipcode -- 邮政编码
            ,principal -- 负责人
            ,belongorgid -- 权属机构
            ,inputorg -- 登记机构
            ,orgoldname -- 机构曾用名
            ,setupdate -- 机构成立日期
            ,businesshours -- 营业时间
            ,updateorg -- 更新机构
            ,inputtime -- 登记时间
            ,inputdate -- 
            ,banklicense -- 金融许可证编号
            ,mainframeexgid -- 交换号
            ,ishs -- 是否是记账机构,码值：YesNo
            ,orgname -- 机构名称
            ,remark -- 备注
            ,vitualserialno -- 虚拟流水号
            ,bankid -- 人行金融机构编码
            ,sortno -- 排序号
            ,mainframeorgid -- 网点号
            ,title -- 职务
            ,fixphone -- 传真
            ,contactpeople -- 联系人
            ,mobiletel -- 联系人手机号码
            ,email -- 电子邮箱
            ,orgalias -- 机构批复简称
            ,belongorglevel -- 上级机构层级
            ,icmsorglevel -- 信贷机构层级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.orgid -- 机构编号
    ,o.orgstatus -- 机构状态
    ,o.orgadd -- 机构地址
    ,o.cmnum -- 客户经理数
    ,o.hostno -- 主机号
    ,o.corporgid -- 法人机构编号
    ,o.vitualid -- 虚拟柜员号
    ,o.inputuser -- 登记人
    ,o.updatedate -- 
    ,o.orglevel -- 机构级别
    ,o.orgclass -- 机构类型
    ,o.orgcode -- 机构编码
    ,o.updateuser -- 更新人
    ,o.orgproperty -- 属性集
    ,o.relativeorgid -- 上级机构编号
    ,o.orgtel -- 联系电话
    ,o.businesslicense -- 营业执照机构级别
    ,o.branchnum -- 管辖网点数
    ,o.updatetime -- 更新时间
    ,o.belongarea -- 行政区划
    ,o.zipcode -- 邮政编码
    ,o.principal -- 负责人
    ,o.belongorgid -- 权属机构
    ,o.inputorg -- 登记机构
    ,o.orgoldname -- 机构曾用名
    ,o.setupdate -- 机构成立日期
    ,o.businesshours -- 营业时间
    ,o.updateorg -- 更新机构
    ,o.inputtime -- 登记时间
    ,o.inputdate -- 
    ,o.banklicense -- 金融许可证编号
    ,o.mainframeexgid -- 交换号
    ,o.ishs -- 是否是记账机构,码值：YesNo
    ,o.orgname -- 机构名称
    ,o.remark -- 备注
    ,o.vitualserialno -- 虚拟流水号
    ,o.bankid -- 人行金融机构编码
    ,o.sortno -- 排序号
    ,o.mainframeorgid -- 网点号
    ,o.title -- 职务
    ,o.fixphone -- 传真
    ,o.contactpeople -- 联系人
    ,o.mobiletel -- 联系人手机号码
    ,o.email -- 电子邮箱
    ,o.orgalias -- 机构批复简称
    ,o.belongorglevel -- 上级机构层级
    ,o.icmsorglevel -- 信贷机构层级
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
from ${iol_schema}.icms_org_info_bk o
    left join ${iol_schema}.icms_org_info_op n
        on
            o.orgid = n.orgid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_org_info_cl d
        on
            o.orgid = d.orgid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_org_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_org_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_org_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_org_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_org_info exchange partition p_${batch_date} with table ${iol_schema}.icms_org_info_cl;
alter table ${iol_schema}.icms_org_info exchange partition p_20991231 with table ${iol_schema}.icms_org_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_org_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_org_info_op purge;
drop table ${iol_schema}.icms_org_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_org_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_org_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
