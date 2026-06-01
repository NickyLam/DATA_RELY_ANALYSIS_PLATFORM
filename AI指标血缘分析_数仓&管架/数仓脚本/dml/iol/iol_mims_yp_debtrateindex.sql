/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_yp_debtrateindex
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
create table ${iol_schema}.mims_yp_debtrateindex_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_yp_debtrateindex
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_yp_debtrateindex_op purge;
drop table ${iol_schema}.mims_yp_debtrateindex_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_debtrateindex_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_yp_debtrateindex where 0=1;

create table ${iol_schema}.mims_yp_debtrateindex_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_yp_debtrateindex where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_yp_debtrateindex_cl(
            workdate -- 供数日期
            ,custid -- 客户编号
            ,sccode -- 押品编号
            ,asscontno -- 担保合同号
            ,ishighasscon -- 是否最高额担保(1-是 0-否)
            ,guartype1 -- 担保一级分类
            ,guartype2 -- 担保二级分类
            ,guartype3 -- 担保三级分类
            ,guaramt -- 抵质押金额
            ,currency -- 币种
            ,guarterms -- 覆盖期限(月)
            ,effectdate -- 生效日
            ,remainterms -- 剩余覆盖期限(月)
            ,regulatorytype -- 监管分类(2、金融质押品 3、其他抵质押品 4、商住房地产和居住用房地产 5、应收账款)
            ,qualification -- 合格性(1-合格 0-不合格)
            ,releaseagent -- 金融质押品发行机构(01-主权（不含公共部门实体）、02-其他发行者、03-证券化风险暴露)
            ,issuercountry -- 金融质押品发行人注册地所在国家或地区(目前只有国债、地方政府债、金融债券有此信息)
            ,transtype -- 交易类型(3-抵押贷款)
            ,evalfrequency -- 再重估频率
            ,controlchange -- 质押物控制力调整系数
            ,realestateregion -- 房地产所在地区
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_yp_debtrateindex_op(
            workdate -- 供数日期
            ,custid -- 客户编号
            ,sccode -- 押品编号
            ,asscontno -- 担保合同号
            ,ishighasscon -- 是否最高额担保(1-是 0-否)
            ,guartype1 -- 担保一级分类
            ,guartype2 -- 担保二级分类
            ,guartype3 -- 担保三级分类
            ,guaramt -- 抵质押金额
            ,currency -- 币种
            ,guarterms -- 覆盖期限(月)
            ,effectdate -- 生效日
            ,remainterms -- 剩余覆盖期限(月)
            ,regulatorytype -- 监管分类(2、金融质押品 3、其他抵质押品 4、商住房地产和居住用房地产 5、应收账款)
            ,qualification -- 合格性(1-合格 0-不合格)
            ,releaseagent -- 金融质押品发行机构(01-主权（不含公共部门实体）、02-其他发行者、03-证券化风险暴露)
            ,issuercountry -- 金融质押品发行人注册地所在国家或地区(目前只有国债、地方政府债、金融债券有此信息)
            ,transtype -- 交易类型(3-抵押贷款)
            ,evalfrequency -- 再重估频率
            ,controlchange -- 质押物控制力调整系数
            ,realestateregion -- 房地产所在地区
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.workdate, o.workdate) as workdate -- 供数日期
    ,nvl(n.custid, o.custid) as custid -- 客户编号
    ,nvl(n.sccode, o.sccode) as sccode -- 押品编号
    ,nvl(n.asscontno, o.asscontno) as asscontno -- 担保合同号
    ,nvl(n.ishighasscon, o.ishighasscon) as ishighasscon -- 是否最高额担保(1-是 0-否)
    ,nvl(n.guartype1, o.guartype1) as guartype1 -- 担保一级分类
    ,nvl(n.guartype2, o.guartype2) as guartype2 -- 担保二级分类
    ,nvl(n.guartype3, o.guartype3) as guartype3 -- 担保三级分类
    ,nvl(n.guaramt, o.guaramt) as guaramt -- 抵质押金额
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.guarterms, o.guarterms) as guarterms -- 覆盖期限(月)
    ,nvl(n.effectdate, o.effectdate) as effectdate -- 生效日
    ,nvl(n.remainterms, o.remainterms) as remainterms -- 剩余覆盖期限(月)
    ,nvl(n.regulatorytype, o.regulatorytype) as regulatorytype -- 监管分类(2、金融质押品 3、其他抵质押品 4、商住房地产和居住用房地产 5、应收账款)
    ,nvl(n.qualification, o.qualification) as qualification -- 合格性(1-合格 0-不合格)
    ,nvl(n.releaseagent, o.releaseagent) as releaseagent -- 金融质押品发行机构(01-主权（不含公共部门实体）、02-其他发行者、03-证券化风险暴露)
    ,nvl(n.issuercountry, o.issuercountry) as issuercountry -- 金融质押品发行人注册地所在国家或地区(目前只有国债、地方政府债、金融债券有此信息)
    ,nvl(n.transtype, o.transtype) as transtype -- 交易类型(3-抵押贷款)
    ,nvl(n.evalfrequency, o.evalfrequency) as evalfrequency -- 再重估频率
    ,nvl(n.controlchange, o.controlchange) as controlchange -- 质押物控制力调整系数
    ,nvl(n.realestateregion, o.realestateregion) as realestateregion -- 房地产所在地区
    ,case when
            n.workdate is null
            and n.sccode is null
            and n.asscontno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.workdate is null
            and n.sccode is null
            and n.asscontno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.workdate is null
            and n.sccode is null
            and n.asscontno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_yp_debtrateindex_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_yp_debtrateindex where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.workdate = n.workdate
            and o.sccode = n.sccode
            and o.asscontno = n.asscontno
where (
        o.workdate is null
        and o.sccode is null
        and o.asscontno is null
    )
    or (
        n.workdate is null
        and n.sccode is null
        and n.asscontno is null
    )
    or (
        o.custid <> n.custid
        or o.ishighasscon <> n.ishighasscon
        or o.guartype1 <> n.guartype1
        or o.guartype2 <> n.guartype2
        or o.guartype3 <> n.guartype3
        or o.guaramt <> n.guaramt
        or o.currency <> n.currency
        or o.guarterms <> n.guarterms
        or o.effectdate <> n.effectdate
        or o.remainterms <> n.remainterms
        or o.regulatorytype <> n.regulatorytype
        or o.qualification <> n.qualification
        or o.releaseagent <> n.releaseagent
        or o.issuercountry <> n.issuercountry
        or o.transtype <> n.transtype
        or o.evalfrequency <> n.evalfrequency
        or o.controlchange <> n.controlchange
        or o.realestateregion <> n.realestateregion
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_yp_debtrateindex_cl(
            workdate -- 供数日期
            ,custid -- 客户编号
            ,sccode -- 押品编号
            ,asscontno -- 担保合同号
            ,ishighasscon -- 是否最高额担保(1-是 0-否)
            ,guartype1 -- 担保一级分类
            ,guartype2 -- 担保二级分类
            ,guartype3 -- 担保三级分类
            ,guaramt -- 抵质押金额
            ,currency -- 币种
            ,guarterms -- 覆盖期限(月)
            ,effectdate -- 生效日
            ,remainterms -- 剩余覆盖期限(月)
            ,regulatorytype -- 监管分类(2、金融质押品 3、其他抵质押品 4、商住房地产和居住用房地产 5、应收账款)
            ,qualification -- 合格性(1-合格 0-不合格)
            ,releaseagent -- 金融质押品发行机构(01-主权（不含公共部门实体）、02-其他发行者、03-证券化风险暴露)
            ,issuercountry -- 金融质押品发行人注册地所在国家或地区(目前只有国债、地方政府债、金融债券有此信息)
            ,transtype -- 交易类型(3-抵押贷款)
            ,evalfrequency -- 再重估频率
            ,controlchange -- 质押物控制力调整系数
            ,realestateregion -- 房地产所在地区
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_yp_debtrateindex_op(
            workdate -- 供数日期
            ,custid -- 客户编号
            ,sccode -- 押品编号
            ,asscontno -- 担保合同号
            ,ishighasscon -- 是否最高额担保(1-是 0-否)
            ,guartype1 -- 担保一级分类
            ,guartype2 -- 担保二级分类
            ,guartype3 -- 担保三级分类
            ,guaramt -- 抵质押金额
            ,currency -- 币种
            ,guarterms -- 覆盖期限(月)
            ,effectdate -- 生效日
            ,remainterms -- 剩余覆盖期限(月)
            ,regulatorytype -- 监管分类(2、金融质押品 3、其他抵质押品 4、商住房地产和居住用房地产 5、应收账款)
            ,qualification -- 合格性(1-合格 0-不合格)
            ,releaseagent -- 金融质押品发行机构(01-主权（不含公共部门实体）、02-其他发行者、03-证券化风险暴露)
            ,issuercountry -- 金融质押品发行人注册地所在国家或地区(目前只有国债、地方政府债、金融债券有此信息)
            ,transtype -- 交易类型(3-抵押贷款)
            ,evalfrequency -- 再重估频率
            ,controlchange -- 质押物控制力调整系数
            ,realestateregion -- 房地产所在地区
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.workdate -- 供数日期
    ,o.custid -- 客户编号
    ,o.sccode -- 押品编号
    ,o.asscontno -- 担保合同号
    ,o.ishighasscon -- 是否最高额担保(1-是 0-否)
    ,o.guartype1 -- 担保一级分类
    ,o.guartype2 -- 担保二级分类
    ,o.guartype3 -- 担保三级分类
    ,o.guaramt -- 抵质押金额
    ,o.currency -- 币种
    ,o.guarterms -- 覆盖期限(月)
    ,o.effectdate -- 生效日
    ,o.remainterms -- 剩余覆盖期限(月)
    ,o.regulatorytype -- 监管分类(2、金融质押品 3、其他抵质押品 4、商住房地产和居住用房地产 5、应收账款)
    ,o.qualification -- 合格性(1-合格 0-不合格)
    ,o.releaseagent -- 金融质押品发行机构(01-主权（不含公共部门实体）、02-其他发行者、03-证券化风险暴露)
    ,o.issuercountry -- 金融质押品发行人注册地所在国家或地区(目前只有国债、地方政府债、金融债券有此信息)
    ,o.transtype -- 交易类型(3-抵押贷款)
    ,o.evalfrequency -- 再重估频率
    ,o.controlchange -- 质押物控制力调整系数
    ,o.realestateregion -- 房地产所在地区
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
from ${iol_schema}.mims_yp_debtrateindex_bk o
    left join ${iol_schema}.mims_yp_debtrateindex_op n
        on
            o.workdate = n.workdate
            and o.sccode = n.sccode
            and o.asscontno = n.asscontno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_yp_debtrateindex_cl d
        on
            o.workdate = d.workdate
            and o.sccode = d.sccode
            and o.asscontno = d.asscontno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mims_yp_debtrateindex;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mims_yp_debtrateindex') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mims_yp_debtrateindex drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mims_yp_debtrateindex add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mims_yp_debtrateindex exchange partition p_${batch_date} with table ${iol_schema}.mims_yp_debtrateindex_cl;
alter table ${iol_schema}.mims_yp_debtrateindex exchange partition p_20991231 with table ${iol_schema}.mims_yp_debtrateindex_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_yp_debtrateindex to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_yp_debtrateindex_op purge;
drop table ${iol_schema}.mims_yp_debtrateindex_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_yp_debtrateindex_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_yp_debtrateindex',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
