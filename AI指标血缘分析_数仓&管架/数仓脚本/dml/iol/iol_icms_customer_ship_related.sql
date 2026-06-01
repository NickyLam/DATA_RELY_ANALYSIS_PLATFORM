/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_ship_related
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
create table ${iol_schema}.icms_customer_ship_related_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_ship_related
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_ship_related_op purge;
drop table ${iol_schema}.icms_customer_ship_related_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_ship_related_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_ship_related where 0=1;

create table ${iol_schema}.icms_customer_ship_related_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_ship_related where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_ship_related_cl(
            serialno -- 流水号
            ,relationship -- 关联关系
            ,comoperiationyear -- 合作年限
            ,customerid -- 客户编号
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,legalname -- 法人代表（公司）
            ,updateuserid -- 更新人
            ,maincustomerid -- 主客户号
            ,settlenentmode -- 结算方式
            ,creditinstitutioncode -- 机构信用代码
            ,certtype -- 关联方证件类型
            ,customername -- 关联方姓名
            ,supplyvalue -- 供应（销售）额
            ,loancardno -- 关联方贷款卡编号
            ,corporgid -- 法人机构编号
            ,migtflag -- 
            ,updateorgid -- 更新机构
            ,production -- 供应(销售)产品
            ,certid -- 关联方证件号码
            ,inputuserid -- 登记人
            ,isaffenterprises -- 是否关联企业
            ,remark -- 备注
            ,inputdate -- 登记日期
            ,investdate -- 关系建立时间
            ,supplyname -- 供应（销售）产品
            ,supplycurrency -- 供应（销售）额币种
            ,supplyprop -- 供应（销售）比例
            ,groupid -- 所属供应链客户群编号
            ,describe -- 构成关联方理由
            ,migtoldvalue -- 备份原字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_ship_related_op(
            serialno -- 流水号
            ,relationship -- 关联关系
            ,comoperiationyear -- 合作年限
            ,customerid -- 客户编号
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,legalname -- 法人代表（公司）
            ,updateuserid -- 更新人
            ,maincustomerid -- 主客户号
            ,settlenentmode -- 结算方式
            ,creditinstitutioncode -- 机构信用代码
            ,certtype -- 关联方证件类型
            ,customername -- 关联方姓名
            ,supplyvalue -- 供应（销售）额
            ,loancardno -- 关联方贷款卡编号
            ,corporgid -- 法人机构编号
            ,migtflag -- 
            ,updateorgid -- 更新机构
            ,production -- 供应(销售)产品
            ,certid -- 关联方证件号码
            ,inputuserid -- 登记人
            ,isaffenterprises -- 是否关联企业
            ,remark -- 备注
            ,inputdate -- 登记日期
            ,investdate -- 关系建立时间
            ,supplyname -- 供应（销售）产品
            ,supplycurrency -- 供应（销售）额币种
            ,supplyprop -- 供应（销售）比例
            ,groupid -- 所属供应链客户群编号
            ,describe -- 构成关联方理由
            ,migtoldvalue -- 备份原字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.relationship, o.relationship) as relationship -- 关联关系
    ,nvl(n.comoperiationyear, o.comoperiationyear) as comoperiationyear -- 合作年限
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.legalname, o.legalname) as legalname -- 法人代表（公司）
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.maincustomerid, o.maincustomerid) as maincustomerid -- 主客户号
    ,nvl(n.settlenentmode, o.settlenentmode) as settlenentmode -- 结算方式
    ,nvl(n.creditinstitutioncode, o.creditinstitutioncode) as creditinstitutioncode -- 机构信用代码
    ,nvl(n.certtype, o.certtype) as certtype -- 关联方证件类型
    ,nvl(n.customername, o.customername) as customername -- 关联方姓名
    ,nvl(n.supplyvalue, o.supplyvalue) as supplyvalue -- 供应（销售）额
    ,nvl(n.loancardno, o.loancardno) as loancardno -- 关联方贷款卡编号
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.production, o.production) as production -- 供应(销售)产品
    ,nvl(n.certid, o.certid) as certid -- 关联方证件号码
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.isaffenterprises, o.isaffenterprises) as isaffenterprises -- 是否关联企业
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.investdate, o.investdate) as investdate -- 关系建立时间
    ,nvl(n.supplyname, o.supplyname) as supplyname -- 供应（销售）产品
    ,nvl(n.supplycurrency, o.supplycurrency) as supplycurrency -- 供应（销售）额币种
    ,nvl(n.supplyprop, o.supplyprop) as supplyprop -- 供应（销售）比例
    ,nvl(n.groupid, o.groupid) as groupid -- 所属供应链客户群编号
    ,nvl(n.describe, o.describe) as describe -- 构成关联方理由
    ,nvl(n.migtoldvalue, o.migtoldvalue) as migtoldvalue -- 备份原字段值
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
from (select * from ${iol_schema}.icms_customer_ship_related_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_ship_related where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.relationship <> n.relationship
        or o.comoperiationyear <> n.comoperiationyear
        or o.customerid <> n.customerid
        or o.inputorgid <> n.inputorgid
        or o.updatedate <> n.updatedate
        or o.legalname <> n.legalname
        or o.updateuserid <> n.updateuserid
        or o.maincustomerid <> n.maincustomerid
        or o.settlenentmode <> n.settlenentmode
        or o.creditinstitutioncode <> n.creditinstitutioncode
        or o.certtype <> n.certtype
        or o.customername <> n.customername
        or o.supplyvalue <> n.supplyvalue
        or o.loancardno <> n.loancardno
        or o.corporgid <> n.corporgid
        or o.migtflag <> n.migtflag
        or o.updateorgid <> n.updateorgid
        or o.production <> n.production
        or o.certid <> n.certid
        or o.inputuserid <> n.inputuserid
        or o.isaffenterprises <> n.isaffenterprises
        or o.remark <> n.remark
        or o.inputdate <> n.inputdate
        or o.investdate <> n.investdate
        or o.supplyname <> n.supplyname
        or o.supplycurrency <> n.supplycurrency
        or o.supplyprop <> n.supplyprop
        or o.groupid <> n.groupid
        or o.describe <> n.describe
        or o.migtoldvalue <> n.migtoldvalue
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_ship_related_cl(
            serialno -- 流水号
            ,relationship -- 关联关系
            ,comoperiationyear -- 合作年限
            ,customerid -- 客户编号
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,legalname -- 法人代表（公司）
            ,updateuserid -- 更新人
            ,maincustomerid -- 主客户号
            ,settlenentmode -- 结算方式
            ,creditinstitutioncode -- 机构信用代码
            ,certtype -- 关联方证件类型
            ,customername -- 关联方姓名
            ,supplyvalue -- 供应（销售）额
            ,loancardno -- 关联方贷款卡编号
            ,corporgid -- 法人机构编号
            ,migtflag -- 
            ,updateorgid -- 更新机构
            ,production -- 供应(销售)产品
            ,certid -- 关联方证件号码
            ,inputuserid -- 登记人
            ,isaffenterprises -- 是否关联企业
            ,remark -- 备注
            ,inputdate -- 登记日期
            ,investdate -- 关系建立时间
            ,supplyname -- 供应（销售）产品
            ,supplycurrency -- 供应（销售）额币种
            ,supplyprop -- 供应（销售）比例
            ,groupid -- 所属供应链客户群编号
            ,describe -- 构成关联方理由
            ,migtoldvalue -- 备份原字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_ship_related_op(
            serialno -- 流水号
            ,relationship -- 关联关系
            ,comoperiationyear -- 合作年限
            ,customerid -- 客户编号
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,legalname -- 法人代表（公司）
            ,updateuserid -- 更新人
            ,maincustomerid -- 主客户号
            ,settlenentmode -- 结算方式
            ,creditinstitutioncode -- 机构信用代码
            ,certtype -- 关联方证件类型
            ,customername -- 关联方姓名
            ,supplyvalue -- 供应（销售）额
            ,loancardno -- 关联方贷款卡编号
            ,corporgid -- 法人机构编号
            ,migtflag -- 
            ,updateorgid -- 更新机构
            ,production -- 供应(销售)产品
            ,certid -- 关联方证件号码
            ,inputuserid -- 登记人
            ,isaffenterprises -- 是否关联企业
            ,remark -- 备注
            ,inputdate -- 登记日期
            ,investdate -- 关系建立时间
            ,supplyname -- 供应（销售）产品
            ,supplycurrency -- 供应（销售）额币种
            ,supplyprop -- 供应（销售）比例
            ,groupid -- 所属供应链客户群编号
            ,describe -- 构成关联方理由
            ,migtoldvalue -- 备份原字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.relationship -- 关联关系
    ,o.comoperiationyear -- 合作年限
    ,o.customerid -- 客户编号
    ,o.inputorgid -- 登记机构
    ,o.updatedate -- 更新日期
    ,o.legalname -- 法人代表（公司）
    ,o.updateuserid -- 更新人
    ,o.maincustomerid -- 主客户号
    ,o.settlenentmode -- 结算方式
    ,o.creditinstitutioncode -- 机构信用代码
    ,o.certtype -- 关联方证件类型
    ,o.customername -- 关联方姓名
    ,o.supplyvalue -- 供应（销售）额
    ,o.loancardno -- 关联方贷款卡编号
    ,o.corporgid -- 法人机构编号
    ,o.migtflag -- 
    ,o.updateorgid -- 更新机构
    ,o.production -- 供应(销售)产品
    ,o.certid -- 关联方证件号码
    ,o.inputuserid -- 登记人
    ,o.isaffenterprises -- 是否关联企业
    ,o.remark -- 备注
    ,o.inputdate -- 登记日期
    ,o.investdate -- 关系建立时间
    ,o.supplyname -- 供应（销售）产品
    ,o.supplycurrency -- 供应（销售）额币种
    ,o.supplyprop -- 供应（销售）比例
    ,o.groupid -- 所属供应链客户群编号
    ,o.describe -- 构成关联方理由
    ,o.migtoldvalue -- 备份原字段值
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
from ${iol_schema}.icms_customer_ship_related_bk o
    left join ${iol_schema}.icms_customer_ship_related_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_ship_related_cl d
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
--truncate table ${iol_schema}.icms_customer_ship_related;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_ship_related') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_ship_related drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_ship_related add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_ship_related exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_ship_related_cl;
alter table ${iol_schema}.icms_customer_ship_related exchange partition p_20991231 with table ${iol_schema}.icms_customer_ship_related_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_ship_related to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_ship_related_op purge;
drop table ${iol_schema}.icms_customer_ship_related_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_ship_related_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_ship_related',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
