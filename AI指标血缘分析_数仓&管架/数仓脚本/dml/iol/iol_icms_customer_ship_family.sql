/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_ship_family
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
create table ${iol_schema}.icms_customer_ship_family_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_ship_family
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_ship_family_op purge;
drop table ${iol_schema}.icms_customer_ship_family_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_ship_family_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_ship_family where 0=1;

create table ${iol_schema}.icms_customer_ship_family_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_ship_family where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_ship_family_cl(
            serialno -- 流水号
            ,updateorgid -- 更新机构
            ,birthday -- 出生日期
            ,workaddress -- 公司地址
            ,corporgid -- 法人机构编号
            ,inputorgid -- 登记机构
            ,areacode -- 区号
            ,remark -- 备注
            ,customerid -- 客户编号
            ,relationship -- 家族关系
            ,worktel -- 家庭成员所在单位电话
            ,maincustomerid -- 主客户号
            ,updateuserid -- 更新人
            ,customername -- 家族成员姓名
            ,address -- 地址
            ,eduexperience -- 最高学历
            ,monthincome -- 月收入
            ,certid -- 证件号码
            ,countryzone -- 联系人座机
            ,indtel -- 联系电话
            ,certtype -- 证件类型
            ,inputuserid -- 登记人
            ,workstartdate -- 参加工作年份
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,entloancardno -- 家族成员所在企业贷款卡编号
            ,entname -- 家族成员所在企业名称
            ,unitcountry -- 单位所在地编码
            ,unitcountryname -- 所在地名称
            ,migtoldvalue -- 备份原字段值
            ,certstartdate -- 
            ,certduedate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_ship_family_op(
            serialno -- 流水号
            ,updateorgid -- 更新机构
            ,birthday -- 出生日期
            ,workaddress -- 公司地址
            ,corporgid -- 法人机构编号
            ,inputorgid -- 登记机构
            ,areacode -- 区号
            ,remark -- 备注
            ,customerid -- 客户编号
            ,relationship -- 家族关系
            ,worktel -- 家庭成员所在单位电话
            ,maincustomerid -- 主客户号
            ,updateuserid -- 更新人
            ,customername -- 家族成员姓名
            ,address -- 地址
            ,eduexperience -- 最高学历
            ,monthincome -- 月收入
            ,certid -- 证件号码
            ,countryzone -- 联系人座机
            ,indtel -- 联系电话
            ,certtype -- 证件类型
            ,inputuserid -- 登记人
            ,workstartdate -- 参加工作年份
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,entloancardno -- 家族成员所在企业贷款卡编号
            ,entname -- 家族成员所在企业名称
            ,unitcountry -- 单位所在地编码
            ,unitcountryname -- 所在地名称
            ,migtoldvalue -- 备份原字段值
            ,certstartdate -- 
            ,certduedate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.birthday, o.birthday) as birthday -- 出生日期
    ,nvl(n.workaddress, o.workaddress) as workaddress -- 公司地址
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.areacode, o.areacode) as areacode -- 区号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.relationship, o.relationship) as relationship -- 家族关系
    ,nvl(n.worktel, o.worktel) as worktel -- 家庭成员所在单位电话
    ,nvl(n.maincustomerid, o.maincustomerid) as maincustomerid -- 主客户号
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.customername, o.customername) as customername -- 家族成员姓名
    ,nvl(n.address, o.address) as address -- 地址
    ,nvl(n.eduexperience, o.eduexperience) as eduexperience -- 最高学历
    ,nvl(n.monthincome, o.monthincome) as monthincome -- 月收入
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.countryzone, o.countryzone) as countryzone -- 联系人座机
    ,nvl(n.indtel, o.indtel) as indtel -- 联系电话
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.workstartdate, o.workstartdate) as workstartdate -- 参加工作年份
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.entloancardno, o.entloancardno) as entloancardno -- 家族成员所在企业贷款卡编号
    ,nvl(n.entname, o.entname) as entname -- 家族成员所在企业名称
    ,nvl(n.unitcountry, o.unitcountry) as unitcountry -- 单位所在地编码
    ,nvl(n.unitcountryname, o.unitcountryname) as unitcountryname -- 所在地名称
    ,nvl(n.migtoldvalue, o.migtoldvalue) as migtoldvalue -- 备份原字段值
    ,nvl(n.certstartdate, o.certstartdate) as certstartdate -- 
    ,nvl(n.certduedate, o.certduedate) as certduedate -- 
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
from (select * from ${iol_schema}.icms_customer_ship_family_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_ship_family where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.updateorgid <> n.updateorgid
        or o.birthday <> n.birthday
        or o.workaddress <> n.workaddress
        or o.corporgid <> n.corporgid
        or o.inputorgid <> n.inputorgid
        or o.areacode <> n.areacode
        or o.remark <> n.remark
        or o.customerid <> n.customerid
        or o.relationship <> n.relationship
        or o.worktel <> n.worktel
        or o.maincustomerid <> n.maincustomerid
        or o.updateuserid <> n.updateuserid
        or o.customername <> n.customername
        or o.address <> n.address
        or o.eduexperience <> n.eduexperience
        or o.monthincome <> n.monthincome
        or o.certid <> n.certid
        or o.countryzone <> n.countryzone
        or o.indtel <> n.indtel
        or o.certtype <> n.certtype
        or o.inputuserid <> n.inputuserid
        or o.workstartdate <> n.workstartdate
        or o.migtflag <> n.migtflag
        or o.inputdate <> n.inputdate
        or o.updatedate <> n.updatedate
        or o.entloancardno <> n.entloancardno
        or o.entname <> n.entname
        or o.unitcountry <> n.unitcountry
        or o.unitcountryname <> n.unitcountryname
        or o.migtoldvalue <> n.migtoldvalue
        or o.certstartdate <> n.certstartdate
        or o.certduedate <> n.certduedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_ship_family_cl(
            serialno -- 流水号
            ,updateorgid -- 更新机构
            ,birthday -- 出生日期
            ,workaddress -- 公司地址
            ,corporgid -- 法人机构编号
            ,inputorgid -- 登记机构
            ,areacode -- 区号
            ,remark -- 备注
            ,customerid -- 客户编号
            ,relationship -- 家族关系
            ,worktel -- 家庭成员所在单位电话
            ,maincustomerid -- 主客户号
            ,updateuserid -- 更新人
            ,customername -- 家族成员姓名
            ,address -- 地址
            ,eduexperience -- 最高学历
            ,monthincome -- 月收入
            ,certid -- 证件号码
            ,countryzone -- 联系人座机
            ,indtel -- 联系电话
            ,certtype -- 证件类型
            ,inputuserid -- 登记人
            ,workstartdate -- 参加工作年份
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,entloancardno -- 家族成员所在企业贷款卡编号
            ,entname -- 家族成员所在企业名称
            ,unitcountry -- 单位所在地编码
            ,unitcountryname -- 所在地名称
            ,migtoldvalue -- 备份原字段值
            ,certstartdate -- 
            ,certduedate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_ship_family_op(
            serialno -- 流水号
            ,updateorgid -- 更新机构
            ,birthday -- 出生日期
            ,workaddress -- 公司地址
            ,corporgid -- 法人机构编号
            ,inputorgid -- 登记机构
            ,areacode -- 区号
            ,remark -- 备注
            ,customerid -- 客户编号
            ,relationship -- 家族关系
            ,worktel -- 家庭成员所在单位电话
            ,maincustomerid -- 主客户号
            ,updateuserid -- 更新人
            ,customername -- 家族成员姓名
            ,address -- 地址
            ,eduexperience -- 最高学历
            ,monthincome -- 月收入
            ,certid -- 证件号码
            ,countryzone -- 联系人座机
            ,indtel -- 联系电话
            ,certtype -- 证件类型
            ,inputuserid -- 登记人
            ,workstartdate -- 参加工作年份
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,entloancardno -- 家族成员所在企业贷款卡编号
            ,entname -- 家族成员所在企业名称
            ,unitcountry -- 单位所在地编码
            ,unitcountryname -- 所在地名称
            ,migtoldvalue -- 备份原字段值
            ,certstartdate -- 
            ,certduedate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.updateorgid -- 更新机构
    ,o.birthday -- 出生日期
    ,o.workaddress -- 公司地址
    ,o.corporgid -- 法人机构编号
    ,o.inputorgid -- 登记机构
    ,o.areacode -- 区号
    ,o.remark -- 备注
    ,o.customerid -- 客户编号
    ,o.relationship -- 家族关系
    ,o.worktel -- 家庭成员所在单位电话
    ,o.maincustomerid -- 主客户号
    ,o.updateuserid -- 更新人
    ,o.customername -- 家族成员姓名
    ,o.address -- 地址
    ,o.eduexperience -- 最高学历
    ,o.monthincome -- 月收入
    ,o.certid -- 证件号码
    ,o.countryzone -- 联系人座机
    ,o.indtel -- 联系电话
    ,o.certtype -- 证件类型
    ,o.inputuserid -- 登记人
    ,o.workstartdate -- 参加工作年份
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.inputdate -- 登记日期
    ,o.updatedate -- 更新日期
    ,o.entloancardno -- 家族成员所在企业贷款卡编号
    ,o.entname -- 家族成员所在企业名称
    ,o.unitcountry -- 单位所在地编码
    ,o.unitcountryname -- 所在地名称
    ,o.migtoldvalue -- 备份原字段值
    ,o.certstartdate -- 
    ,o.certduedate -- 
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
from ${iol_schema}.icms_customer_ship_family_bk o
    left join ${iol_schema}.icms_customer_ship_family_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_ship_family_cl d
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
--truncate table ${iol_schema}.icms_customer_ship_family;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_ship_family') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_ship_family drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_ship_family add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_ship_family exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_ship_family_cl;
alter table ${iol_schema}.icms_customer_ship_family exchange partition p_20991231 with table ${iol_schema}.icms_customer_ship_family_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_ship_family to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_ship_family_op purge;
drop table ${iol_schema}.icms_customer_ship_family_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_ship_family_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_ship_family',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
