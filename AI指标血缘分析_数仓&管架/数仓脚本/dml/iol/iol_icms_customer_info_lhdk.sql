/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_info_lhdk
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
create table ${iol_schema}.icms_customer_info_lhdk_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_info_lhdk
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_info_lhdk_op purge;
drop table ${iol_schema}.icms_customer_info_lhdk_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_info_lhdk_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_info_lhdk where 0=1;

create table ${iol_schema}.icms_customer_info_lhdk_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_info_lhdk where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_info_lhdk_cl(
            customerid -- 客户号
            ,customername -- 客户姓名
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,certstartdate -- 证件起始日
            ,certmaturity -- 证件到期日
            ,sex -- 性别
            ,occupation -- 职业
            ,nation -- 国籍
            ,address -- 地址
            ,telephone -- 联系电话
            ,isfarmer -- 农户标志
            ,indtype -- 客户性质
            ,indincome -- 个人收入（元）
            ,homeincome -- 家庭收入（元）
            ,accountno -- 银行卡号
            ,accountbankname -- 开户行名称
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,workno -- 单位编号
            ,workname -- 单位名称
            ,unitaddress -- 单位地址
            ,unitpostcode -- 单位地址邮政编码
            ,liveaddress -- 居住地址
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,comcrddt -- 信用评级时间
            ,comcrdgrade -- 客户信用评级
            ,comcrdscore -- 信用评级积分
            ,disabledflag -- 是否残疾人
            ,familyfarmflag -- 是否家庭农场
            ,lowincomeflag -- 是否低保户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_info_lhdk_op(
            customerid -- 客户号
            ,customername -- 客户姓名
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,certstartdate -- 证件起始日
            ,certmaturity -- 证件到期日
            ,sex -- 性别
            ,occupation -- 职业
            ,nation -- 国籍
            ,address -- 地址
            ,telephone -- 联系电话
            ,isfarmer -- 农户标志
            ,indtype -- 客户性质
            ,indincome -- 个人收入（元）
            ,homeincome -- 家庭收入（元）
            ,accountno -- 银行卡号
            ,accountbankname -- 开户行名称
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,workno -- 单位编号
            ,workname -- 单位名称
            ,unitaddress -- 单位地址
            ,unitpostcode -- 单位地址邮政编码
            ,liveaddress -- 居住地址
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,comcrddt -- 信用评级时间
            ,comcrdgrade -- 客户信用评级
            ,comcrdscore -- 信用评级积分
            ,disabledflag -- 是否残疾人
            ,familyfarmflag -- 是否家庭农场
            ,lowincomeflag -- 是否低保户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.customername, o.customername) as customername -- 客户姓名
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.certstartdate, o.certstartdate) as certstartdate -- 证件起始日
    ,nvl(n.certmaturity, o.certmaturity) as certmaturity -- 证件到期日
    ,nvl(n.sex, o.sex) as sex -- 性别
    ,nvl(n.occupation, o.occupation) as occupation -- 职业
    ,nvl(n.nation, o.nation) as nation -- 国籍
    ,nvl(n.address, o.address) as address -- 地址
    ,nvl(n.telephone, o.telephone) as telephone -- 联系电话
    ,nvl(n.isfarmer, o.isfarmer) as isfarmer -- 农户标志
    ,nvl(n.indtype, o.indtype) as indtype -- 客户性质
    ,nvl(n.indincome, o.indincome) as indincome -- 个人收入（元）
    ,nvl(n.homeincome, o.homeincome) as homeincome -- 家庭收入（元）
    ,nvl(n.accountno, o.accountno) as accountno -- 银行卡号
    ,nvl(n.accountbankname, o.accountbankname) as accountbankname -- 开户行名称
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.workno, o.workno) as workno -- 单位编号
    ,nvl(n.workname, o.workname) as workname -- 单位名称
    ,nvl(n.unitaddress, o.unitaddress) as unitaddress -- 单位地址
    ,nvl(n.unitpostcode, o.unitpostcode) as unitpostcode -- 单位地址邮政编码
    ,nvl(n.liveaddress, o.liveaddress) as liveaddress -- 居住地址
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.comcrddt, o.comcrddt) as comcrddt -- 信用评级时间
    ,nvl(n.comcrdgrade, o.comcrdgrade) as comcrdgrade -- 客户信用评级
    ,nvl(n.comcrdscore, o.comcrdscore) as comcrdscore -- 信用评级积分
    ,nvl(n.disabledflag, o.disabledflag) as disabledflag -- 是否残疾人
    ,nvl(n.familyfarmflag, o.familyfarmflag) as familyfarmflag -- 是否家庭农场
    ,nvl(n.lowincomeflag, o.lowincomeflag) as lowincomeflag -- 是否低保户
    ,case when
            n.customerid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.customerid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.customerid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_customer_info_lhdk_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_info_lhdk where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.customerid = n.customerid
where (
        o.customerid is null
    )
    or (
        n.customerid is null
    )
    or (
        o.customername <> n.customername
        or o.certtype <> n.certtype
        or o.certid <> n.certid
        or o.certstartdate <> n.certstartdate
        or o.certmaturity <> n.certmaturity
        or o.sex <> n.sex
        or o.occupation <> n.occupation
        or o.nation <> n.nation
        or o.address <> n.address
        or o.telephone <> n.telephone
        or o.isfarmer <> n.isfarmer
        or o.indtype <> n.indtype
        or o.indincome <> n.indincome
        or o.homeincome <> n.homeincome
        or o.accountno <> n.accountno
        or o.accountbankname <> n.accountbankname
        or o.migtflag <> n.migtflag
        or o.workno <> n.workno
        or o.workname <> n.workname
        or o.unitaddress <> n.unitaddress
        or o.unitpostcode <> n.unitpostcode
        or o.liveaddress <> n.liveaddress
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.comcrddt <> n.comcrddt
        or o.comcrdgrade <> n.comcrdgrade
        or o.comcrdscore <> n.comcrdscore
        or o.disabledflag <> n.disabledflag
        or o.familyfarmflag <> n.familyfarmflag
        or o.lowincomeflag <> n.lowincomeflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_info_lhdk_cl(
            customerid -- 客户号
            ,customername -- 客户姓名
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,certstartdate -- 证件起始日
            ,certmaturity -- 证件到期日
            ,sex -- 性别
            ,occupation -- 职业
            ,nation -- 国籍
            ,address -- 地址
            ,telephone -- 联系电话
            ,isfarmer -- 农户标志
            ,indtype -- 客户性质
            ,indincome -- 个人收入（元）
            ,homeincome -- 家庭收入（元）
            ,accountno -- 银行卡号
            ,accountbankname -- 开户行名称
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,workno -- 单位编号
            ,workname -- 单位名称
            ,unitaddress -- 单位地址
            ,unitpostcode -- 单位地址邮政编码
            ,liveaddress -- 居住地址
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,comcrddt -- 信用评级时间
            ,comcrdgrade -- 客户信用评级
            ,comcrdscore -- 信用评级积分
            ,disabledflag -- 是否残疾人
            ,familyfarmflag -- 是否家庭农场
            ,lowincomeflag -- 是否低保户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_info_lhdk_op(
            customerid -- 客户号
            ,customername -- 客户姓名
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,certstartdate -- 证件起始日
            ,certmaturity -- 证件到期日
            ,sex -- 性别
            ,occupation -- 职业
            ,nation -- 国籍
            ,address -- 地址
            ,telephone -- 联系电话
            ,isfarmer -- 农户标志
            ,indtype -- 客户性质
            ,indincome -- 个人收入（元）
            ,homeincome -- 家庭收入（元）
            ,accountno -- 银行卡号
            ,accountbankname -- 开户行名称
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,workno -- 单位编号
            ,workname -- 单位名称
            ,unitaddress -- 单位地址
            ,unitpostcode -- 单位地址邮政编码
            ,liveaddress -- 居住地址
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,comcrddt -- 信用评级时间
            ,comcrdgrade -- 客户信用评级
            ,comcrdscore -- 信用评级积分
            ,disabledflag -- 是否残疾人
            ,familyfarmflag -- 是否家庭农场
            ,lowincomeflag -- 是否低保户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.customerid -- 客户号
    ,o.customername -- 客户姓名
    ,o.certtype -- 证件类型
    ,o.certid -- 证件号码
    ,o.certstartdate -- 证件起始日
    ,o.certmaturity -- 证件到期日
    ,o.sex -- 性别
    ,o.occupation -- 职业
    ,o.nation -- 国籍
    ,o.address -- 地址
    ,o.telephone -- 联系电话
    ,o.isfarmer -- 农户标志
    ,o.indtype -- 客户性质
    ,o.indincome -- 个人收入（元）
    ,o.homeincome -- 家庭收入（元）
    ,o.accountno -- 银行卡号
    ,o.accountbankname -- 开户行名称
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.workno -- 单位编号
    ,o.workname -- 单位名称
    ,o.unitaddress -- 单位地址
    ,o.unitpostcode -- 单位地址邮政编码
    ,o.liveaddress -- 居住地址
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.comcrddt -- 信用评级时间
    ,o.comcrdgrade -- 客户信用评级
    ,o.comcrdscore -- 信用评级积分
    ,o.disabledflag -- 是否残疾人
    ,o.familyfarmflag -- 是否家庭农场
    ,o.lowincomeflag -- 是否低保户
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
from ${iol_schema}.icms_customer_info_lhdk_bk o
    left join ${iol_schema}.icms_customer_info_lhdk_op n
        on
            o.customerid = n.customerid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_info_lhdk_cl d
        on
            o.customerid = d.customerid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_customer_info_lhdk;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_info_lhdk') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_info_lhdk drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_info_lhdk add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_info_lhdk exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_info_lhdk_cl;
alter table ${iol_schema}.icms_customer_info_lhdk exchange partition p_20991231 with table ${iol_schema}.icms_customer_info_lhdk_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_info_lhdk to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_info_lhdk_op purge;
drop table ${iol_schema}.icms_customer_info_lhdk_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_info_lhdk_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_info_lhdk',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
