/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_valueinfohis
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
create table ${iol_schema}.mims_si_valueinfohis_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_valueinfohis;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_valueinfohis_op purge;
drop table ${iol_schema}.mims_si_valueinfohis_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_valueinfohis_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_valueinfohis where 0=1;

create table ${iol_schema}.mims_si_valueinfohis_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_valueinfohis where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_valueinfohis_cl(
            sccode -- 押品编号
            ,evalmode -- 评估方式 01-外部评估      02-内部评估      03-外部和内部评估
            ,evaldate -- 评估日期 评估价值评估的日期
            ,curreny -- 币种
            ,rate -- 汇率
            ,outevalexpdate -- 外部评估价值有效期截止日
            ,outevaldeptcode -- 外部评估机构
            ,outevalmethod -- 外部评估方法 01-指数法_外部指数        02-指数法_内部构建指数        03-市场法        04-收益法        05-重置成本法        06-工程进度法        07-非上市公司股权净资产比例法        08-直接引用法_金融质抵质押品        09-直接引用法_动产        10-直接引用法_房地产        11-直接引用法_询价        12-其他
            ,outevalflag -- 是否有外部预评估报告 0-否            1-是
            ,outevalamt1 -- 外部预评估报告的评估价值
            ,outevaldate -- 外部正式评估报告评估日期
            ,outevalamt -- 外部正式评估报告的评估价值
            ,evalamt -- 内部评估价值 根据内部评估方法计算出的内部评估价值
            ,evalamt2 -- 申请评估确认价值 分析外部评估和内部评估价值后，客户经理得出评估确认价值
            ,businessinsid -- 流程编号 我行确认价值对应的流程编号，如我行确认价值为自动重估得到，则该字段为空
            ,confmamt -- 我行确认价值
            ,condate -- 评估认定日期
            ,firstoutevalamt -- 初评外部正式评估价值
            ,firstevalamt -- 初评内部评估价值 根据内部评估方法计算出的内部评估价值
            ,firstconfmamt -- 初评我行确认价值
            ,startbusinessinsid -- 初评流程编号
            ,verecoginition -- 押品价值认定方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_valueinfohis_op(
            sccode -- 押品编号
            ,evalmode -- 评估方式 01-外部评估      02-内部评估      03-外部和内部评估
            ,evaldate -- 评估日期 评估价值评估的日期
            ,curreny -- 币种
            ,rate -- 汇率
            ,outevalexpdate -- 外部评估价值有效期截止日
            ,outevaldeptcode -- 外部评估机构
            ,outevalmethod -- 外部评估方法 01-指数法_外部指数        02-指数法_内部构建指数        03-市场法        04-收益法        05-重置成本法        06-工程进度法        07-非上市公司股权净资产比例法        08-直接引用法_金融质抵质押品        09-直接引用法_动产        10-直接引用法_房地产        11-直接引用法_询价        12-其他
            ,outevalflag -- 是否有外部预评估报告 0-否            1-是
            ,outevalamt1 -- 外部预评估报告的评估价值
            ,outevaldate -- 外部正式评估报告评估日期
            ,outevalamt -- 外部正式评估报告的评估价值
            ,evalamt -- 内部评估价值 根据内部评估方法计算出的内部评估价值
            ,evalamt2 -- 申请评估确认价值 分析外部评估和内部评估价值后，客户经理得出评估确认价值
            ,businessinsid -- 流程编号 我行确认价值对应的流程编号，如我行确认价值为自动重估得到，则该字段为空
            ,confmamt -- 我行确认价值
            ,condate -- 评估认定日期
            ,firstoutevalamt -- 初评外部正式评估价值
            ,firstevalamt -- 初评内部评估价值 根据内部评估方法计算出的内部评估价值
            ,firstconfmamt -- 初评我行确认价值
            ,startbusinessinsid -- 初评流程编号
            ,verecoginition -- 押品价值认定方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 押品编号
    ,nvl(n.evalmode, o.evalmode) as evalmode -- 评估方式 01-外部评估      02-内部评估      03-外部和内部评估
    ,nvl(n.evaldate, o.evaldate) as evaldate -- 评估日期 评估价值评估的日期
    ,nvl(n.curreny, o.curreny) as curreny -- 币种
    ,nvl(n.rate, o.rate) as rate -- 汇率
    ,nvl(n.outevalexpdate, o.outevalexpdate) as outevalexpdate -- 外部评估价值有效期截止日
    ,nvl(n.outevaldeptcode, o.outevaldeptcode) as outevaldeptcode -- 外部评估机构
    ,nvl(n.outevalmethod, o.outevalmethod) as outevalmethod -- 外部评估方法 01-指数法_外部指数        02-指数法_内部构建指数        03-市场法        04-收益法        05-重置成本法        06-工程进度法        07-非上市公司股权净资产比例法        08-直接引用法_金融质抵质押品        09-直接引用法_动产        10-直接引用法_房地产        11-直接引用法_询价        12-其他
    ,nvl(n.outevalflag, o.outevalflag) as outevalflag -- 是否有外部预评估报告 0-否            1-是
    ,nvl(n.outevalamt1, o.outevalamt1) as outevalamt1 -- 外部预评估报告的评估价值
    ,nvl(n.outevaldate, o.outevaldate) as outevaldate -- 外部正式评估报告评估日期
    ,nvl(n.outevalamt, o.outevalamt) as outevalamt -- 外部正式评估报告的评估价值
    ,nvl(n.evalamt, o.evalamt) as evalamt -- 内部评估价值 根据内部评估方法计算出的内部评估价值
    ,nvl(n.evalamt2, o.evalamt2) as evalamt2 -- 申请评估确认价值 分析外部评估和内部评估价值后，客户经理得出评估确认价值
    ,nvl(n.businessinsid, o.businessinsid) as businessinsid -- 流程编号 我行确认价值对应的流程编号，如我行确认价值为自动重估得到，则该字段为空
    ,nvl(n.confmamt, o.confmamt) as confmamt -- 我行确认价值
    ,nvl(n.condate, o.condate) as condate -- 评估认定日期
    ,nvl(n.firstoutevalamt, o.firstoutevalamt) as firstoutevalamt -- 初评外部正式评估价值
    ,nvl(n.firstevalamt, o.firstevalamt) as firstevalamt -- 初评内部评估价值 根据内部评估方法计算出的内部评估价值
    ,nvl(n.firstconfmamt, o.firstconfmamt) as firstconfmamt -- 初评我行确认价值
    ,nvl(n.startbusinessinsid, o.startbusinessinsid) as startbusinessinsid -- 初评流程编号
    ,nvl(n.verecoginition, o.verecoginition) as verecoginition -- 押品价值认定方式
    ,case when
            n.sccode is null
            and n.condate is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sccode is null
            and n.condate is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sccode is null
            and n.condate is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_si_valueinfohis_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_valueinfohis where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
            and o.condate = n.condate
where (
        o.sccode is null
        and o.condate is null
    )
    or (
        n.sccode is null
        and n.condate is null
    )
    or (
        o.evalmode <> n.evalmode
        or o.evaldate <> n.evaldate
        or o.curreny <> n.curreny
        or o.rate <> n.rate
        or o.outevalexpdate <> n.outevalexpdate
        or o.outevaldeptcode <> n.outevaldeptcode
        or o.outevalmethod <> n.outevalmethod
        or o.outevalflag <> n.outevalflag
        or o.outevalamt1 <> n.outevalamt1
        or o.outevaldate <> n.outevaldate
        or o.outevalamt <> n.outevalamt
        or o.evalamt <> n.evalamt
        or o.evalamt2 <> n.evalamt2
        or o.businessinsid <> n.businessinsid
        or o.confmamt <> n.confmamt
        or o.firstoutevalamt <> n.firstoutevalamt
        or o.firstevalamt <> n.firstevalamt
        or o.firstconfmamt <> n.firstconfmamt
        or o.startbusinessinsid <> n.startbusinessinsid
        or o.verecoginition <> n.verecoginition
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_valueinfohis_cl(
            sccode -- 押品编号
            ,evalmode -- 评估方式 01-外部评估      02-内部评估      03-外部和内部评估
            ,evaldate -- 评估日期 评估价值评估的日期
            ,curreny -- 币种
            ,rate -- 汇率
            ,outevalexpdate -- 外部评估价值有效期截止日
            ,outevaldeptcode -- 外部评估机构
            ,outevalmethod -- 外部评估方法 01-指数法_外部指数        02-指数法_内部构建指数        03-市场法        04-收益法        05-重置成本法        06-工程进度法        07-非上市公司股权净资产比例法        08-直接引用法_金融质抵质押品        09-直接引用法_动产        10-直接引用法_房地产        11-直接引用法_询价        12-其他
            ,outevalflag -- 是否有外部预评估报告 0-否            1-是
            ,outevalamt1 -- 外部预评估报告的评估价值
            ,outevaldate -- 外部正式评估报告评估日期
            ,outevalamt -- 外部正式评估报告的评估价值
            ,evalamt -- 内部评估价值 根据内部评估方法计算出的内部评估价值
            ,evalamt2 -- 申请评估确认价值 分析外部评估和内部评估价值后，客户经理得出评估确认价值
            ,businessinsid -- 流程编号 我行确认价值对应的流程编号，如我行确认价值为自动重估得到，则该字段为空
            ,confmamt -- 我行确认价值
            ,condate -- 评估认定日期
            ,firstoutevalamt -- 初评外部正式评估价值
            ,firstevalamt -- 初评内部评估价值 根据内部评估方法计算出的内部评估价值
            ,firstconfmamt -- 初评我行确认价值
            ,startbusinessinsid -- 初评流程编号
            ,verecoginition -- 押品价值认定方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_valueinfohis_op(
            sccode -- 押品编号
            ,evalmode -- 评估方式 01-外部评估      02-内部评估      03-外部和内部评估
            ,evaldate -- 评估日期 评估价值评估的日期
            ,curreny -- 币种
            ,rate -- 汇率
            ,outevalexpdate -- 外部评估价值有效期截止日
            ,outevaldeptcode -- 外部评估机构
            ,outevalmethod -- 外部评估方法 01-指数法_外部指数        02-指数法_内部构建指数        03-市场法        04-收益法        05-重置成本法        06-工程进度法        07-非上市公司股权净资产比例法        08-直接引用法_金融质抵质押品        09-直接引用法_动产        10-直接引用法_房地产        11-直接引用法_询价        12-其他
            ,outevalflag -- 是否有外部预评估报告 0-否            1-是
            ,outevalamt1 -- 外部预评估报告的评估价值
            ,outevaldate -- 外部正式评估报告评估日期
            ,outevalamt -- 外部正式评估报告的评估价值
            ,evalamt -- 内部评估价值 根据内部评估方法计算出的内部评估价值
            ,evalamt2 -- 申请评估确认价值 分析外部评估和内部评估价值后，客户经理得出评估确认价值
            ,businessinsid -- 流程编号 我行确认价值对应的流程编号，如我行确认价值为自动重估得到，则该字段为空
            ,confmamt -- 我行确认价值
            ,condate -- 评估认定日期
            ,firstoutevalamt -- 初评外部正式评估价值
            ,firstevalamt -- 初评内部评估价值 根据内部评估方法计算出的内部评估价值
            ,firstconfmamt -- 初评我行确认价值
            ,startbusinessinsid -- 初评流程编号
            ,verecoginition -- 押品价值认定方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 押品编号
    ,o.evalmode -- 评估方式 01-外部评估      02-内部评估      03-外部和内部评估
    ,o.evaldate -- 评估日期 评估价值评估的日期
    ,o.curreny -- 币种
    ,o.rate -- 汇率
    ,o.outevalexpdate -- 外部评估价值有效期截止日
    ,o.outevaldeptcode -- 外部评估机构
    ,o.outevalmethod -- 外部评估方法 01-指数法_外部指数        02-指数法_内部构建指数        03-市场法        04-收益法        05-重置成本法        06-工程进度法        07-非上市公司股权净资产比例法        08-直接引用法_金融质抵质押品        09-直接引用法_动产        10-直接引用法_房地产        11-直接引用法_询价        12-其他
    ,o.outevalflag -- 是否有外部预评估报告 0-否            1-是
    ,o.outevalamt1 -- 外部预评估报告的评估价值
    ,o.outevaldate -- 外部正式评估报告评估日期
    ,o.outevalamt -- 外部正式评估报告的评估价值
    ,o.evalamt -- 内部评估价值 根据内部评估方法计算出的内部评估价值
    ,o.evalamt2 -- 申请评估确认价值 分析外部评估和内部评估价值后，客户经理得出评估确认价值
    ,o.businessinsid -- 流程编号 我行确认价值对应的流程编号，如我行确认价值为自动重估得到，则该字段为空
    ,o.confmamt -- 我行确认价值
    ,o.condate -- 评估认定日期
    ,o.firstoutevalamt -- 初评外部正式评估价值
    ,o.firstevalamt -- 初评内部评估价值 根据内部评估方法计算出的内部评估价值
    ,o.firstconfmamt -- 初评我行确认价值
    ,o.startbusinessinsid -- 初评流程编号
    ,o.verecoginition -- 押品价值认定方式
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_si_valueinfohis_bk o
    left join ${iol_schema}.mims_si_valueinfohis_op n
        on
            o.sccode = n.sccode
            and o.condate = n.condate
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_valueinfohis_cl d
        on
            o.sccode = d.sccode
            and o.condate = d.condate
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mims_si_valueinfohis;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_si_valueinfohis exchange partition p_19000101 with table ${iol_schema}.mims_si_valueinfohis_cl;
alter table ${iol_schema}.mims_si_valueinfohis exchange partition p_20991231 with table ${iol_schema}.mims_si_valueinfohis_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_valueinfohis to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_valueinfohis_op purge;
drop table ${iol_schema}.mims_si_valueinfohis_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_valueinfohis_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_valueinfohis',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
