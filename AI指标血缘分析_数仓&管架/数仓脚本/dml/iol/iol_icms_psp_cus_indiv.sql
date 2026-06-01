/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_psp_cus_indiv
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
create table ${iol_schema}.icms_psp_cus_indiv_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_psp_cus_indiv
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_psp_cus_indiv_op purge;
drop table ${iol_schema}.icms_psp_cus_indiv_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_psp_cus_indiv_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_psp_cus_indiv where 0=1;

create table ${iol_schema}.icms_psp_cus_indiv_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_psp_cus_indiv where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_psp_cus_indiv_cl(
            serialno -- 流水号
            ,indivcomname -- 工作单位
            ,indivcomfldname -- 单位所属行业名称
            ,lastupddate -- 最近更新日期
            ,comscale -- 企业规模
            ,commrkflg -- 是否上市
            ,customername -- 客户名称
            ,mobile -- 联系电话
            ,lastupdid -- 最近更新人
            ,comname -- 企业名称
            ,crdgrade -- 本期信用等级
            ,indivhealst -- 健康状况
            ,comtype -- 所属行业
            ,personnum -- 家庭人口
            ,customerid -- 客户号
            ,certcode -- 证件号码
            ,indivcomfld -- 单位所属行业
            ,postaddr -- 通讯地址
            ,comgrpname -- 所属集团
            ,cusstartdate -- 首次建立信贷关系时间
            ,cusgrade -- 客户评级
            ,indivcomjobttl -- 职务
            ,comflg -- 是否民营
            ,relativeserialno -- 任务编号
            ,custype -- 1-借款人，2-自然人，3-法人,4-专项检查,5、合作商
            ,indivmarst -- 婚姻状况
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,modeltype -- 产品类别
            ,indivocc -- 职业
            ,certtype -- 证件类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_psp_cus_indiv_op(
            serialno -- 流水号
            ,indivcomname -- 工作单位
            ,indivcomfldname -- 单位所属行业名称
            ,lastupddate -- 最近更新日期
            ,comscale -- 企业规模
            ,commrkflg -- 是否上市
            ,customername -- 客户名称
            ,mobile -- 联系电话
            ,lastupdid -- 最近更新人
            ,comname -- 企业名称
            ,crdgrade -- 本期信用等级
            ,indivhealst -- 健康状况
            ,comtype -- 所属行业
            ,personnum -- 家庭人口
            ,customerid -- 客户号
            ,certcode -- 证件号码
            ,indivcomfld -- 单位所属行业
            ,postaddr -- 通讯地址
            ,comgrpname -- 所属集团
            ,cusstartdate -- 首次建立信贷关系时间
            ,cusgrade -- 客户评级
            ,indivcomjobttl -- 职务
            ,comflg -- 是否民营
            ,relativeserialno -- 任务编号
            ,custype -- 1-借款人，2-自然人，3-法人,4-专项检查,5、合作商
            ,indivmarst -- 婚姻状况
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,modeltype -- 产品类别
            ,indivocc -- 职业
            ,certtype -- 证件类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.indivcomname, o.indivcomname) as indivcomname -- 工作单位
    ,nvl(n.indivcomfldname, o.indivcomfldname) as indivcomfldname -- 单位所属行业名称
    ,nvl(n.lastupddate, o.lastupddate) as lastupddate -- 最近更新日期
    ,nvl(n.comscale, o.comscale) as comscale -- 企业规模
    ,nvl(n.commrkflg, o.commrkflg) as commrkflg -- 是否上市
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.mobile, o.mobile) as mobile -- 联系电话
    ,nvl(n.lastupdid, o.lastupdid) as lastupdid -- 最近更新人
    ,nvl(n.comname, o.comname) as comname -- 企业名称
    ,nvl(n.crdgrade, o.crdgrade) as crdgrade -- 本期信用等级
    ,nvl(n.indivhealst, o.indivhealst) as indivhealst -- 健康状况
    ,nvl(n.comtype, o.comtype) as comtype -- 所属行业
    ,nvl(n.personnum, o.personnum) as personnum -- 家庭人口
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.certcode, o.certcode) as certcode -- 证件号码
    ,nvl(n.indivcomfld, o.indivcomfld) as indivcomfld -- 单位所属行业
    ,nvl(n.postaddr, o.postaddr) as postaddr -- 通讯地址
    ,nvl(n.comgrpname, o.comgrpname) as comgrpname -- 所属集团
    ,nvl(n.cusstartdate, o.cusstartdate) as cusstartdate -- 首次建立信贷关系时间
    ,nvl(n.cusgrade, o.cusgrade) as cusgrade -- 客户评级
    ,nvl(n.indivcomjobttl, o.indivcomjobttl) as indivcomjobttl -- 职务
    ,nvl(n.comflg, o.comflg) as comflg -- 是否民营
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 任务编号
    ,nvl(n.custype, o.custype) as custype -- 1-借款人，2-自然人，3-法人,4-专项检查,5、合作商
    ,nvl(n.indivmarst, o.indivmarst) as indivmarst -- 婚姻状况
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.modeltype, o.modeltype) as modeltype -- 产品类别
    ,nvl(n.indivocc, o.indivocc) as indivocc -- 职业
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
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
from (select * from ${iol_schema}.icms_psp_cus_indiv_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_psp_cus_indiv where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.indivcomname <> n.indivcomname
        or o.indivcomfldname <> n.indivcomfldname
        or o.lastupddate <> n.lastupddate
        or o.comscale <> n.comscale
        or o.commrkflg <> n.commrkflg
        or o.customername <> n.customername
        or o.mobile <> n.mobile
        or o.lastupdid <> n.lastupdid
        or o.comname <> n.comname
        or o.crdgrade <> n.crdgrade
        or o.indivhealst <> n.indivhealst
        or o.comtype <> n.comtype
        or o.personnum <> n.personnum
        or o.customerid <> n.customerid
        or o.certcode <> n.certcode
        or o.indivcomfld <> n.indivcomfld
        or o.postaddr <> n.postaddr
        or o.comgrpname <> n.comgrpname
        or o.cusstartdate <> n.cusstartdate
        or o.cusgrade <> n.cusgrade
        or o.indivcomjobttl <> n.indivcomjobttl
        or o.comflg <> n.comflg
        or o.relativeserialno <> n.relativeserialno
        or o.custype <> n.custype
        or o.indivmarst <> n.indivmarst
        or o.migtflag <> n.migtflag
        or o.modeltype <> n.modeltype
        or o.indivocc <> n.indivocc
        or o.certtype <> n.certtype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_psp_cus_indiv_cl(
            serialno -- 流水号
            ,indivcomname -- 工作单位
            ,indivcomfldname -- 单位所属行业名称
            ,lastupddate -- 最近更新日期
            ,comscale -- 企业规模
            ,commrkflg -- 是否上市
            ,customername -- 客户名称
            ,mobile -- 联系电话
            ,lastupdid -- 最近更新人
            ,comname -- 企业名称
            ,crdgrade -- 本期信用等级
            ,indivhealst -- 健康状况
            ,comtype -- 所属行业
            ,personnum -- 家庭人口
            ,customerid -- 客户号
            ,certcode -- 证件号码
            ,indivcomfld -- 单位所属行业
            ,postaddr -- 通讯地址
            ,comgrpname -- 所属集团
            ,cusstartdate -- 首次建立信贷关系时间
            ,cusgrade -- 客户评级
            ,indivcomjobttl -- 职务
            ,comflg -- 是否民营
            ,relativeserialno -- 任务编号
            ,custype -- 1-借款人，2-自然人，3-法人,4-专项检查,5、合作商
            ,indivmarst -- 婚姻状况
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,modeltype -- 产品类别
            ,indivocc -- 职业
            ,certtype -- 证件类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_psp_cus_indiv_op(
            serialno -- 流水号
            ,indivcomname -- 工作单位
            ,indivcomfldname -- 单位所属行业名称
            ,lastupddate -- 最近更新日期
            ,comscale -- 企业规模
            ,commrkflg -- 是否上市
            ,customername -- 客户名称
            ,mobile -- 联系电话
            ,lastupdid -- 最近更新人
            ,comname -- 企业名称
            ,crdgrade -- 本期信用等级
            ,indivhealst -- 健康状况
            ,comtype -- 所属行业
            ,personnum -- 家庭人口
            ,customerid -- 客户号
            ,certcode -- 证件号码
            ,indivcomfld -- 单位所属行业
            ,postaddr -- 通讯地址
            ,comgrpname -- 所属集团
            ,cusstartdate -- 首次建立信贷关系时间
            ,cusgrade -- 客户评级
            ,indivcomjobttl -- 职务
            ,comflg -- 是否民营
            ,relativeserialno -- 任务编号
            ,custype -- 1-借款人，2-自然人，3-法人,4-专项检查,5、合作商
            ,indivmarst -- 婚姻状况
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,modeltype -- 产品类别
            ,indivocc -- 职业
            ,certtype -- 证件类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.indivcomname -- 工作单位
    ,o.indivcomfldname -- 单位所属行业名称
    ,o.lastupddate -- 最近更新日期
    ,o.comscale -- 企业规模
    ,o.commrkflg -- 是否上市
    ,o.customername -- 客户名称
    ,o.mobile -- 联系电话
    ,o.lastupdid -- 最近更新人
    ,o.comname -- 企业名称
    ,o.crdgrade -- 本期信用等级
    ,o.indivhealst -- 健康状况
    ,o.comtype -- 所属行业
    ,o.personnum -- 家庭人口
    ,o.customerid -- 客户号
    ,o.certcode -- 证件号码
    ,o.indivcomfld -- 单位所属行业
    ,o.postaddr -- 通讯地址
    ,o.comgrpname -- 所属集团
    ,o.cusstartdate -- 首次建立信贷关系时间
    ,o.cusgrade -- 客户评级
    ,o.indivcomjobttl -- 职务
    ,o.comflg -- 是否民营
    ,o.relativeserialno -- 任务编号
    ,o.custype -- 1-借款人，2-自然人，3-法人,4-专项检查,5、合作商
    ,o.indivmarst -- 婚姻状况
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.modeltype -- 产品类别
    ,o.indivocc -- 职业
    ,o.certtype -- 证件类型
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
from ${iol_schema}.icms_psp_cus_indiv_bk o
    left join ${iol_schema}.icms_psp_cus_indiv_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_psp_cus_indiv_cl d
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
--truncate table ${iol_schema}.icms_psp_cus_indiv;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_psp_cus_indiv') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_psp_cus_indiv drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_psp_cus_indiv add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_psp_cus_indiv exchange partition p_${batch_date} with table ${iol_schema}.icms_psp_cus_indiv_cl;
alter table ${iol_schema}.icms_psp_cus_indiv exchange partition p_20991231 with table ${iol_schema}.icms_psp_cus_indiv_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_psp_cus_indiv to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_psp_cus_indiv_op purge;
drop table ${iol_schema}.icms_psp_cus_indiv_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_psp_cus_indiv_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_psp_cus_indiv',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
