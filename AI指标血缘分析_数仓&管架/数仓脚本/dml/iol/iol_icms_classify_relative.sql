/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_classify_relative
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
create table ${iol_schema}.icms_classify_relative_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_classify_relative
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_classify_relative_op purge;
drop table ${iol_schema}.icms_classify_relative_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_classify_relative_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_classify_relative where 0=1;

create table ${iol_schema}.icms_classify_relative_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_classify_relative where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_classify_relative_cl(
            serialno -- 关联流水号
            ,objecttype -- 关联类型
            ,objectno -- 关联编号
            ,guarantorid -- 保证人
            ,relativedate -- 关联日期
            ,inputdate -- 登记时间
            ,limitelement -- 限定因素
            ,updateorgid -- 更新机构
            ,remark -- 备注
            ,adjustreason -- 调整理由
            ,inputuserid -- 登记人
            ,vouchtype -- 担保类型
            ,interestbalance -- 关注余额
            ,status -- 状态
            ,evaluateresult -- 业务评级结果
            ,guarantysum -- 保证总金额
            ,updateuserid -- 更新人
            ,businessdescribe -- 业务模式说明/保证措施说明/预警信号描述
            ,signid -- 预警信号编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,coveragearea -- 覆盖率
            ,equitysituation -- 股权情况
            ,businessanalyze -- 押品价格稳定性、变现能力和法律保障分析/担保能力、担保意愿和法律保障分析/我行债券保障能力分析
            ,signlevel -- 预警信号级别
            ,adjust -- 调整
            ,guarantorname -- 保证人
            ,channel -- 渠道
            ,inputorgid -- 登记机构
            ,balance -- 借据余额
            ,updatedate -- 更新时间
            ,afterclassifyresulteleven -- 调整后11级分类
            ,lastclassifyresulteleven -- 调整前11级分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_classify_relative_op(
            serialno -- 关联流水号
            ,objecttype -- 关联类型
            ,objectno -- 关联编号
            ,guarantorid -- 保证人
            ,relativedate -- 关联日期
            ,inputdate -- 登记时间
            ,limitelement -- 限定因素
            ,updateorgid -- 更新机构
            ,remark -- 备注
            ,adjustreason -- 调整理由
            ,inputuserid -- 登记人
            ,vouchtype -- 担保类型
            ,interestbalance -- 关注余额
            ,status -- 状态
            ,evaluateresult -- 业务评级结果
            ,guarantysum -- 保证总金额
            ,updateuserid -- 更新人
            ,businessdescribe -- 业务模式说明/保证措施说明/预警信号描述
            ,signid -- 预警信号编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,coveragearea -- 覆盖率
            ,equitysituation -- 股权情况
            ,businessanalyze -- 押品价格稳定性、变现能力和法律保障分析/担保能力、担保意愿和法律保障分析/我行债券保障能力分析
            ,signlevel -- 预警信号级别
            ,adjust -- 调整
            ,guarantorname -- 保证人
            ,channel -- 渠道
            ,inputorgid -- 登记机构
            ,balance -- 借据余额
            ,updatedate -- 更新时间
            ,afterclassifyresulteleven -- 调整后11级分类
            ,lastclassifyresulteleven -- 调整前11级分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 关联流水号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 关联类型
    ,nvl(n.objectno, o.objectno) as objectno -- 关联编号
    ,nvl(n.guarantorid, o.guarantorid) as guarantorid -- 保证人
    ,nvl(n.relativedate, o.relativedate) as relativedate -- 关联日期
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.limitelement, o.limitelement) as limitelement -- 限定因素
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.adjustreason, o.adjustreason) as adjustreason -- 调整理由
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 担保类型
    ,nvl(n.interestbalance, o.interestbalance) as interestbalance -- 关注余额
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.evaluateresult, o.evaluateresult) as evaluateresult -- 业务评级结果
    ,nvl(n.guarantysum, o.guarantysum) as guarantysum -- 保证总金额
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.businessdescribe, o.businessdescribe) as businessdescribe -- 业务模式说明/保证措施说明/预警信号描述
    ,nvl(n.signid, o.signid) as signid -- 预警信号编号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.coveragearea, o.coveragearea) as coveragearea -- 覆盖率
    ,nvl(n.equitysituation, o.equitysituation) as equitysituation -- 股权情况
    ,nvl(n.businessanalyze, o.businessanalyze) as businessanalyze -- 押品价格稳定性、变现能力和法律保障分析/担保能力、担保意愿和法律保障分析/我行债券保障能力分析
    ,nvl(n.signlevel, o.signlevel) as signlevel -- 预警信号级别
    ,nvl(n.adjust, o.adjust) as adjust -- 调整
    ,nvl(n.guarantorname, o.guarantorname) as guarantorname -- 保证人
    ,nvl(n.channel, o.channel) as channel -- 渠道
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.balance, o.balance) as balance -- 借据余额
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.afterclassifyresulteleven, o.afterclassifyresulteleven) as afterclassifyresulteleven -- 调整后11级分类
    ,nvl(n.lastclassifyresulteleven, o.lastclassifyresulteleven) as lastclassifyresulteleven -- 调整前11级分类
    ,case when
            n.serialno is null
            and n.objecttype is null
            and n.objectno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
            and n.objecttype is null
            and n.objectno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
            and n.objecttype is null
            and n.objectno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_classify_relative_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_classify_relative where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
            and o.objecttype = n.objecttype
            and o.objectno = n.objectno
where (
        o.serialno is null
        and o.objecttype is null
        and o.objectno is null
    )
    or (
        n.serialno is null
        and n.objecttype is null
        and n.objectno is null
    )
    or (
        o.guarantorid <> n.guarantorid
        or o.relativedate <> n.relativedate
        or o.inputdate <> n.inputdate
        or o.limitelement <> n.limitelement
        or o.updateorgid <> n.updateorgid
        or o.remark <> n.remark
        or o.adjustreason <> n.adjustreason
        or o.inputuserid <> n.inputuserid
        or o.vouchtype <> n.vouchtype
        or o.interestbalance <> n.interestbalance
        or o.status <> n.status
        or o.evaluateresult <> n.evaluateresult
        or o.guarantysum <> n.guarantysum
        or o.updateuserid <> n.updateuserid
        or o.businessdescribe <> n.businessdescribe
        or o.signid <> n.signid
        or o.migtflag <> n.migtflag
        or o.coveragearea <> n.coveragearea
        or o.equitysituation <> n.equitysituation
        or o.businessanalyze <> n.businessanalyze
        or o.signlevel <> n.signlevel
        or o.adjust <> n.adjust
        or o.guarantorname <> n.guarantorname
        or o.channel <> n.channel
        or o.inputorgid <> n.inputorgid
        or o.balance <> n.balance
        or o.updatedate <> n.updatedate
        or o.afterclassifyresulteleven <> n.afterclassifyresulteleven
        or o.lastclassifyresulteleven <> n.lastclassifyresulteleven
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_classify_relative_cl(
            serialno -- 关联流水号
            ,objecttype -- 关联类型
            ,objectno -- 关联编号
            ,guarantorid -- 保证人
            ,relativedate -- 关联日期
            ,inputdate -- 登记时间
            ,limitelement -- 限定因素
            ,updateorgid -- 更新机构
            ,remark -- 备注
            ,adjustreason -- 调整理由
            ,inputuserid -- 登记人
            ,vouchtype -- 担保类型
            ,interestbalance -- 关注余额
            ,status -- 状态
            ,evaluateresult -- 业务评级结果
            ,guarantysum -- 保证总金额
            ,updateuserid -- 更新人
            ,businessdescribe -- 业务模式说明/保证措施说明/预警信号描述
            ,signid -- 预警信号编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,coveragearea -- 覆盖率
            ,equitysituation -- 股权情况
            ,businessanalyze -- 押品价格稳定性、变现能力和法律保障分析/担保能力、担保意愿和法律保障分析/我行债券保障能力分析
            ,signlevel -- 预警信号级别
            ,adjust -- 调整
            ,guarantorname -- 保证人
            ,channel -- 渠道
            ,inputorgid -- 登记机构
            ,balance -- 借据余额
            ,updatedate -- 更新时间
            ,afterclassifyresulteleven -- 调整后11级分类
            ,lastclassifyresulteleven -- 调整前11级分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_classify_relative_op(
            serialno -- 关联流水号
            ,objecttype -- 关联类型
            ,objectno -- 关联编号
            ,guarantorid -- 保证人
            ,relativedate -- 关联日期
            ,inputdate -- 登记时间
            ,limitelement -- 限定因素
            ,updateorgid -- 更新机构
            ,remark -- 备注
            ,adjustreason -- 调整理由
            ,inputuserid -- 登记人
            ,vouchtype -- 担保类型
            ,interestbalance -- 关注余额
            ,status -- 状态
            ,evaluateresult -- 业务评级结果
            ,guarantysum -- 保证总金额
            ,updateuserid -- 更新人
            ,businessdescribe -- 业务模式说明/保证措施说明/预警信号描述
            ,signid -- 预警信号编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,coveragearea -- 覆盖率
            ,equitysituation -- 股权情况
            ,businessanalyze -- 押品价格稳定性、变现能力和法律保障分析/担保能力、担保意愿和法律保障分析/我行债券保障能力分析
            ,signlevel -- 预警信号级别
            ,adjust -- 调整
            ,guarantorname -- 保证人
            ,channel -- 渠道
            ,inputorgid -- 登记机构
            ,balance -- 借据余额
            ,updatedate -- 更新时间
            ,afterclassifyresulteleven -- 调整后11级分类
            ,lastclassifyresulteleven -- 调整前11级分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 关联流水号
    ,o.objecttype -- 关联类型
    ,o.objectno -- 关联编号
    ,o.guarantorid -- 保证人
    ,o.relativedate -- 关联日期
    ,o.inputdate -- 登记时间
    ,o.limitelement -- 限定因素
    ,o.updateorgid -- 更新机构
    ,o.remark -- 备注
    ,o.adjustreason -- 调整理由
    ,o.inputuserid -- 登记人
    ,o.vouchtype -- 担保类型
    ,o.interestbalance -- 关注余额
    ,o.status -- 状态
    ,o.evaluateresult -- 业务评级结果
    ,o.guarantysum -- 保证总金额
    ,o.updateuserid -- 更新人
    ,o.businessdescribe -- 业务模式说明/保证措施说明/预警信号描述
    ,o.signid -- 预警信号编号
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.coveragearea -- 覆盖率
    ,o.equitysituation -- 股权情况
    ,o.businessanalyze -- 押品价格稳定性、变现能力和法律保障分析/担保能力、担保意愿和法律保障分析/我行债券保障能力分析
    ,o.signlevel -- 预警信号级别
    ,o.adjust -- 调整
    ,o.guarantorname -- 保证人
    ,o.channel -- 渠道
    ,o.inputorgid -- 登记机构
    ,o.balance -- 借据余额
    ,o.updatedate -- 更新时间
    ,o.afterclassifyresulteleven -- 调整后11级分类
    ,o.lastclassifyresulteleven -- 调整前11级分类
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
from ${iol_schema}.icms_classify_relative_bk o
    left join ${iol_schema}.icms_classify_relative_op n
        on
            o.serialno = n.serialno
            and o.objecttype = n.objecttype
            and o.objectno = n.objectno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_classify_relative_cl d
        on
            o.serialno = d.serialno
            and o.objecttype = d.objecttype
            and o.objectno = d.objectno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_classify_relative;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_classify_relative') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_classify_relative drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_classify_relative add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_classify_relative exchange partition p_${batch_date} with table ${iol_schema}.icms_classify_relative_cl;
alter table ${iol_schema}.icms_classify_relative exchange partition p_20991231 with table ${iol_schema}.icms_classify_relative_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_classify_relative to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_classify_relative_op purge;
drop table ${iol_schema}.icms_classify_relative_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_classify_relative_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_classify_relative',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
