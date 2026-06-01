/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_special
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
create table ${iol_schema}.icms_customer_special_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_special
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_special_op purge;
drop table ${iol_schema}.icms_customer_special_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_special_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_special where 0=1;

create table ${iol_schema}.icms_customer_special_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_special where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_special_cl(
            serialno -- 流水号
            ,email -- 邮箱
            ,controltype -- 控制方式
            ,inputdate -- 登记日期
            ,certtype -- 证件类型
            ,nationcode -- 证件国别
            ,companytel -- 单位电话
            ,relationship -- 关系
            ,shareratio -- 持有本行股份占比
            ,inputuserid -- 登记人编号
            ,customername -- 客户名称
            ,remark -- 备注
            ,updatedate -- 更新日期
            ,source -- 来源描述
            ,content -- 黑名单内容
            ,begindate -- 开始日期
            ,listingplace -- 上市地点
            ,jobtitle -- 职称
            ,platformlevel -- 平台等级
            ,birthday -- 出生日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,relativecustname -- 关联客户名称
            ,educationdegree -- 最高学位
            ,certid -- 证件号码
            ,enddate -- 结束时间
            ,updateuserid -- 更新人编号
            ,inputtype -- 入库类型
            ,corporgid -- 法人机构编号
            ,specialcustomersubtype -- 名单类别-子类
            ,sex -- 性别
            ,inliststatus -- 是否有效
            ,relativecustid -- 关联客户编号
            ,shares -- 持有本行股份数
            ,inputorgid -- 登记机构编号
            ,actualassert -- 实缴资本
            ,updateorgid -- 更新机构编号
            ,approvestatus -- 审批状态
            ,provider -- 名单来源
            ,specialcustomertype -- 名单类别
            ,inlistreason -- 列入原因
            ,industrytype -- 国际行业分类国际行业分类型
            ,reason -- 入库原因
            ,customerid -- 客户编号
            ,mobiletel -- 手机号码
            ,addapprovestatus -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_special_op(
            serialno -- 流水号
            ,email -- 邮箱
            ,controltype -- 控制方式
            ,inputdate -- 登记日期
            ,certtype -- 证件类型
            ,nationcode -- 证件国别
            ,companytel -- 单位电话
            ,relationship -- 关系
            ,shareratio -- 持有本行股份占比
            ,inputuserid -- 登记人编号
            ,customername -- 客户名称
            ,remark -- 备注
            ,updatedate -- 更新日期
            ,source -- 来源描述
            ,content -- 黑名单内容
            ,begindate -- 开始日期
            ,listingplace -- 上市地点
            ,jobtitle -- 职称
            ,platformlevel -- 平台等级
            ,birthday -- 出生日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,relativecustname -- 关联客户名称
            ,educationdegree -- 最高学位
            ,certid -- 证件号码
            ,enddate -- 结束时间
            ,updateuserid -- 更新人编号
            ,inputtype -- 入库类型
            ,corporgid -- 法人机构编号
            ,specialcustomersubtype -- 名单类别-子类
            ,sex -- 性别
            ,inliststatus -- 是否有效
            ,relativecustid -- 关联客户编号
            ,shares -- 持有本行股份数
            ,inputorgid -- 登记机构编号
            ,actualassert -- 实缴资本
            ,updateorgid -- 更新机构编号
            ,approvestatus -- 审批状态
            ,provider -- 名单来源
            ,specialcustomertype -- 名单类别
            ,inlistreason -- 列入原因
            ,industrytype -- 国际行业分类国际行业分类型
            ,reason -- 入库原因
            ,customerid -- 客户编号
            ,mobiletel -- 手机号码
            ,addapprovestatus -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.email, o.email) as email -- 邮箱
    ,nvl(n.controltype, o.controltype) as controltype -- 控制方式
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.nationcode, o.nationcode) as nationcode -- 证件国别
    ,nvl(n.companytel, o.companytel) as companytel -- 单位电话
    ,nvl(n.relationship, o.relationship) as relationship -- 关系
    ,nvl(n.shareratio, o.shareratio) as shareratio -- 持有本行股份占比
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.source, o.source) as source -- 来源描述
    ,nvl(n.content, o.content) as content -- 黑名单内容
    ,nvl(n.begindate, o.begindate) as begindate -- 开始日期
    ,nvl(n.listingplace, o.listingplace) as listingplace -- 上市地点
    ,nvl(n.jobtitle, o.jobtitle) as jobtitle -- 职称
    ,nvl(n.platformlevel, o.platformlevel) as platformlevel -- 平台等级
    ,nvl(n.birthday, o.birthday) as birthday -- 出生日期
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.relativecustname, o.relativecustname) as relativecustname -- 关联客户名称
    ,nvl(n.educationdegree, o.educationdegree) as educationdegree -- 最高学位
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.enddate, o.enddate) as enddate -- 结束时间
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人编号
    ,nvl(n.inputtype, o.inputtype) as inputtype -- 入库类型
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.specialcustomersubtype, o.specialcustomersubtype) as specialcustomersubtype -- 名单类别-子类
    ,nvl(n.sex, o.sex) as sex -- 性别
    ,nvl(n.inliststatus, o.inliststatus) as inliststatus -- 是否有效
    ,nvl(n.relativecustid, o.relativecustid) as relativecustid -- 关联客户编号
    ,nvl(n.shares, o.shares) as shares -- 持有本行股份数
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构编号
    ,nvl(n.actualassert, o.actualassert) as actualassert -- 实缴资本
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构编号
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.provider, o.provider) as provider -- 名单来源
    ,nvl(n.specialcustomertype, o.specialcustomertype) as specialcustomertype -- 名单类别
    ,nvl(n.inlistreason, o.inlistreason) as inlistreason -- 列入原因
    ,nvl(n.industrytype, o.industrytype) as industrytype -- 国际行业分类国际行业分类型
    ,nvl(n.reason, o.reason) as reason -- 入库原因
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.mobiletel, o.mobiletel) as mobiletel -- 手机号码
    ,nvl(n.addapprovestatus, o.addapprovestatus) as addapprovestatus -- 
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_customer_special_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_special where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.email <> n.email
        or o.controltype <> n.controltype
        or o.inputdate <> n.inputdate
        or o.certtype <> n.certtype
        or o.nationcode <> n.nationcode
        or o.companytel <> n.companytel
        or o.relationship <> n.relationship
        or o.shareratio <> n.shareratio
        or o.inputuserid <> n.inputuserid
        or o.customername <> n.customername
        or o.remark <> n.remark
        or o.updatedate <> n.updatedate
        or o.source <> n.source
        or o.content <> n.content
        or o.begindate <> n.begindate
        or o.listingplace <> n.listingplace
        or o.jobtitle <> n.jobtitle
        or o.platformlevel <> n.platformlevel
        or o.birthday <> n.birthday
        or o.migtflag <> n.migtflag
        or o.relativecustname <> n.relativecustname
        or o.educationdegree <> n.educationdegree
        or o.certid <> n.certid
        or o.enddate <> n.enddate
        or o.updateuserid <> n.updateuserid
        or o.inputtype <> n.inputtype
        or o.corporgid <> n.corporgid
        or o.specialcustomersubtype <> n.specialcustomersubtype
        or o.sex <> n.sex
        or o.inliststatus <> n.inliststatus
        or o.relativecustid <> n.relativecustid
        or o.shares <> n.shares
        or o.inputorgid <> n.inputorgid
        or o.actualassert <> n.actualassert
        or o.updateorgid <> n.updateorgid
        or o.approvestatus <> n.approvestatus
        or o.provider <> n.provider
        or o.specialcustomertype <> n.specialcustomertype
        or o.inlistreason <> n.inlistreason
        or o.industrytype <> n.industrytype
        or o.reason <> n.reason
        or o.customerid <> n.customerid
        or o.mobiletel <> n.mobiletel
        or o.addapprovestatus <> n.addapprovestatus
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_special_cl(
            serialno -- 流水号
            ,email -- 邮箱
            ,controltype -- 控制方式
            ,inputdate -- 登记日期
            ,certtype -- 证件类型
            ,nationcode -- 证件国别
            ,companytel -- 单位电话
            ,relationship -- 关系
            ,shareratio -- 持有本行股份占比
            ,inputuserid -- 登记人编号
            ,customername -- 客户名称
            ,remark -- 备注
            ,updatedate -- 更新日期
            ,source -- 来源描述
            ,content -- 黑名单内容
            ,begindate -- 开始日期
            ,listingplace -- 上市地点
            ,jobtitle -- 职称
            ,platformlevel -- 平台等级
            ,birthday -- 出生日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,relativecustname -- 关联客户名称
            ,educationdegree -- 最高学位
            ,certid -- 证件号码
            ,enddate -- 结束时间
            ,updateuserid -- 更新人编号
            ,inputtype -- 入库类型
            ,corporgid -- 法人机构编号
            ,specialcustomersubtype -- 名单类别-子类
            ,sex -- 性别
            ,inliststatus -- 是否有效
            ,relativecustid -- 关联客户编号
            ,shares -- 持有本行股份数
            ,inputorgid -- 登记机构编号
            ,actualassert -- 实缴资本
            ,updateorgid -- 更新机构编号
            ,approvestatus -- 审批状态
            ,provider -- 名单来源
            ,specialcustomertype -- 名单类别
            ,inlistreason -- 列入原因
            ,industrytype -- 国际行业分类国际行业分类型
            ,reason -- 入库原因
            ,customerid -- 客户编号
            ,mobiletel -- 手机号码
            ,addapprovestatus -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_special_op(
            serialno -- 流水号
            ,email -- 邮箱
            ,controltype -- 控制方式
            ,inputdate -- 登记日期
            ,certtype -- 证件类型
            ,nationcode -- 证件国别
            ,companytel -- 单位电话
            ,relationship -- 关系
            ,shareratio -- 持有本行股份占比
            ,inputuserid -- 登记人编号
            ,customername -- 客户名称
            ,remark -- 备注
            ,updatedate -- 更新日期
            ,source -- 来源描述
            ,content -- 黑名单内容
            ,begindate -- 开始日期
            ,listingplace -- 上市地点
            ,jobtitle -- 职称
            ,platformlevel -- 平台等级
            ,birthday -- 出生日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,relativecustname -- 关联客户名称
            ,educationdegree -- 最高学位
            ,certid -- 证件号码
            ,enddate -- 结束时间
            ,updateuserid -- 更新人编号
            ,inputtype -- 入库类型
            ,corporgid -- 法人机构编号
            ,specialcustomersubtype -- 名单类别-子类
            ,sex -- 性别
            ,inliststatus -- 是否有效
            ,relativecustid -- 关联客户编号
            ,shares -- 持有本行股份数
            ,inputorgid -- 登记机构编号
            ,actualassert -- 实缴资本
            ,updateorgid -- 更新机构编号
            ,approvestatus -- 审批状态
            ,provider -- 名单来源
            ,specialcustomertype -- 名单类别
            ,inlistreason -- 列入原因
            ,industrytype -- 国际行业分类国际行业分类型
            ,reason -- 入库原因
            ,customerid -- 客户编号
            ,mobiletel -- 手机号码
            ,addapprovestatus -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.email -- 邮箱
    ,o.controltype -- 控制方式
    ,o.inputdate -- 登记日期
    ,o.certtype -- 证件类型
    ,o.nationcode -- 证件国别
    ,o.companytel -- 单位电话
    ,o.relationship -- 关系
    ,o.shareratio -- 持有本行股份占比
    ,o.inputuserid -- 登记人编号
    ,o.customername -- 客户名称
    ,o.remark -- 备注
    ,o.updatedate -- 更新日期
    ,o.source -- 来源描述
    ,o.content -- 黑名单内容
    ,o.begindate -- 开始日期
    ,o.listingplace -- 上市地点
    ,o.jobtitle -- 职称
    ,o.platformlevel -- 平台等级
    ,o.birthday -- 出生日期
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.relativecustname -- 关联客户名称
    ,o.educationdegree -- 最高学位
    ,o.certid -- 证件号码
    ,o.enddate -- 结束时间
    ,o.updateuserid -- 更新人编号
    ,o.inputtype -- 入库类型
    ,o.corporgid -- 法人机构编号
    ,o.specialcustomersubtype -- 名单类别-子类
    ,o.sex -- 性别
    ,o.inliststatus -- 是否有效
    ,o.relativecustid -- 关联客户编号
    ,o.shares -- 持有本行股份数
    ,o.inputorgid -- 登记机构编号
    ,o.actualassert -- 实缴资本
    ,o.updateorgid -- 更新机构编号
    ,o.approvestatus -- 审批状态
    ,o.provider -- 名单来源
    ,o.specialcustomertype -- 名单类别
    ,o.inlistreason -- 列入原因
    ,o.industrytype -- 国际行业分类国际行业分类型
    ,o.reason -- 入库原因
    ,o.customerid -- 客户编号
    ,o.mobiletel -- 手机号码
    ,o.addapprovestatus -- 
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
from ${iol_schema}.icms_customer_special_bk o
    left join ${iol_schema}.icms_customer_special_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_special_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_customer_special;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_special') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_special drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_special add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_special exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_special_cl;
alter table ${iol_schema}.icms_customer_special exchange partition p_20991231 with table ${iol_schema}.icms_customer_special_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_special to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_special_op purge;
drop table ${iol_schema}.icms_customer_special_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_special_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_special',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
