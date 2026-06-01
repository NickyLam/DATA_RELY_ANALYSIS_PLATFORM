/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_abss_abs_rela_person_info
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
create table ${iol_schema}.abss_abs_rela_person_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.abss_abs_rela_person_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.abss_abs_rela_person_info_op purge;
drop table ${iol_schema}.abss_abs_rela_person_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.abss_abs_rela_person_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.abss_abs_rela_person_info where 0=1;

create table ${iol_schema}.abss_abs_rela_person_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.abss_abs_rela_person_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.abss_abs_rela_person_info_cl(
            relapersonid -- 关系人编号
            ,relapersonname -- 关系人名称
            ,relapersontype -- 关系人属性
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,issuecountry -- 证件签发国家
            ,accountno -- 账户号码
            ,accountname -- 账户名称
            ,accountbank -- 账户开户行
            ,largenumber -- 大额行号
            ,largebankname -- 大额行名称
            ,contact -- 联系人
            ,contactway -- 联系方式
            ,remark -- 备注
            ,inputuserid -- 登记人ID
            ,inputorgid -- 登记机构ID
            ,inputdate -- 登记日期ID
            ,updateuserid -- 更新人ID
            ,updateorgid -- 更新机构ID
            ,updatedate -- 更新日期
            ,tempsaveflag -- 暂存标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.abss_abs_rela_person_info_op(
            relapersonid -- 关系人编号
            ,relapersonname -- 关系人名称
            ,relapersontype -- 关系人属性
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,issuecountry -- 证件签发国家
            ,accountno -- 账户号码
            ,accountname -- 账户名称
            ,accountbank -- 账户开户行
            ,largenumber -- 大额行号
            ,largebankname -- 大额行名称
            ,contact -- 联系人
            ,contactway -- 联系方式
            ,remark -- 备注
            ,inputuserid -- 登记人ID
            ,inputorgid -- 登记机构ID
            ,inputdate -- 登记日期ID
            ,updateuserid -- 更新人ID
            ,updateorgid -- 更新机构ID
            ,updatedate -- 更新日期
            ,tempsaveflag -- 暂存标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.relapersonid, o.relapersonid) as relapersonid -- 关系人编号
    ,nvl(n.relapersonname, o.relapersonname) as relapersonname -- 关系人名称
    ,nvl(n.relapersontype, o.relapersontype) as relapersontype -- 关系人属性
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.issuecountry, o.issuecountry) as issuecountry -- 证件签发国家
    ,nvl(n.accountno, o.accountno) as accountno -- 账户号码
    ,nvl(n.accountname, o.accountname) as accountname -- 账户名称
    ,nvl(n.accountbank, o.accountbank) as accountbank -- 账户开户行
    ,nvl(n.largenumber, o.largenumber) as largenumber -- 大额行号
    ,nvl(n.largebankname, o.largebankname) as largebankname -- 大额行名称
    ,nvl(n.contact, o.contact) as contact -- 联系人
    ,nvl(n.contactway, o.contactway) as contactway -- 联系方式
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人ID
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构ID
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期ID
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人ID
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构ID
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.tempsaveflag, o.tempsaveflag) as tempsaveflag -- 暂存标志
    ,case when
            n.relapersonid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.relapersonid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.relapersonid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.abss_abs_rela_person_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.abss_abs_rela_person_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.relapersonid = n.relapersonid
where (
        o.relapersonid is null
    )
    or (
        n.relapersonid is null
    )
    or (
        o.relapersonname <> n.relapersonname
        or o.relapersontype <> n.relapersontype
        or o.certtype <> n.certtype
        or o.certid <> n.certid
        or o.issuecountry <> n.issuecountry
        or o.accountno <> n.accountno
        or o.accountname <> n.accountname
        or o.accountbank <> n.accountbank
        or o.largenumber <> n.largenumber
        or o.largebankname <> n.largebankname
        or o.contact <> n.contact
        or o.contactway <> n.contactway
        or o.remark <> n.remark
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.tempsaveflag <> n.tempsaveflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.abss_abs_rela_person_info_cl(
            relapersonid -- 关系人编号
            ,relapersonname -- 关系人名称
            ,relapersontype -- 关系人属性
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,issuecountry -- 证件签发国家
            ,accountno -- 账户号码
            ,accountname -- 账户名称
            ,accountbank -- 账户开户行
            ,largenumber -- 大额行号
            ,largebankname -- 大额行名称
            ,contact -- 联系人
            ,contactway -- 联系方式
            ,remark -- 备注
            ,inputuserid -- 登记人ID
            ,inputorgid -- 登记机构ID
            ,inputdate -- 登记日期ID
            ,updateuserid -- 更新人ID
            ,updateorgid -- 更新机构ID
            ,updatedate -- 更新日期
            ,tempsaveflag -- 暂存标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.abss_abs_rela_person_info_op(
            relapersonid -- 关系人编号
            ,relapersonname -- 关系人名称
            ,relapersontype -- 关系人属性
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,issuecountry -- 证件签发国家
            ,accountno -- 账户号码
            ,accountname -- 账户名称
            ,accountbank -- 账户开户行
            ,largenumber -- 大额行号
            ,largebankname -- 大额行名称
            ,contact -- 联系人
            ,contactway -- 联系方式
            ,remark -- 备注
            ,inputuserid -- 登记人ID
            ,inputorgid -- 登记机构ID
            ,inputdate -- 登记日期ID
            ,updateuserid -- 更新人ID
            ,updateorgid -- 更新机构ID
            ,updatedate -- 更新日期
            ,tempsaveflag -- 暂存标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.relapersonid -- 关系人编号
    ,o.relapersonname -- 关系人名称
    ,o.relapersontype -- 关系人属性
    ,o.certtype -- 证件类型
    ,o.certid -- 证件号码
    ,o.issuecountry -- 证件签发国家
    ,o.accountno -- 账户号码
    ,o.accountname -- 账户名称
    ,o.accountbank -- 账户开户行
    ,o.largenumber -- 大额行号
    ,o.largebankname -- 大额行名称
    ,o.contact -- 联系人
    ,o.contactway -- 联系方式
    ,o.remark -- 备注
    ,o.inputuserid -- 登记人ID
    ,o.inputorgid -- 登记机构ID
    ,o.inputdate -- 登记日期ID
    ,o.updateuserid -- 更新人ID
    ,o.updateorgid -- 更新机构ID
    ,o.updatedate -- 更新日期
    ,o.tempsaveflag -- 暂存标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.abss_abs_rela_person_info_bk o
    left join ${iol_schema}.abss_abs_rela_person_info_op n
        on
            o.relapersonid = n.relapersonid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.abss_abs_rela_person_info_cl d
        on
            o.relapersonid = d.relapersonid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.abss_abs_rela_person_info;

-- 4.2 exchange partition
alter table ${iol_schema}.abss_abs_rela_person_info exchange partition p_19000101 with table ${iol_schema}.abss_abs_rela_person_info_cl;
alter table ${iol_schema}.abss_abs_rela_person_info exchange partition p_20991231 with table ${iol_schema}.abss_abs_rela_person_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.abss_abs_rela_person_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.abss_abs_rela_person_info_op purge;
drop table ${iol_schema}.abss_abs_rela_person_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.abss_abs_rela_person_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'abss_abs_rela_person_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
