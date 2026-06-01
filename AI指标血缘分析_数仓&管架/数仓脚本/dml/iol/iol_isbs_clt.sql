/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_clt
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
create table ${iol_schema}.isbs_clt_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_clt;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_clt_op purge;
drop table ${iol_schema}.isbs_clt_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_clt_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_clt where 0=1;

create table ${iol_schema}.isbs_clt_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_clt where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_clt_cl(
            inr -- 光票托收委托托收ID号
            ,resrej -- 拒付的原因
            ,bcgque -- 查询信息
            ,bcgans -- 回答信息
            ,strinf -- 给收单行的信息
            ,intrem -- 备注
            ,selmt -- Swift报文类型
            ,cctfre -- 自由文本
            ,coradrblk -- 汇票受票人地址块
            ,droadrblk -- 付款行地址块
            ,preadrblk -- 托收人/收款人地址块
            ,nobadrblk -- 清算行地址块
            ,dftins -- 单据说明
            ,chgtxt -- 费用文本
            ,intins -- 内部说明
            ,setins -- 结算说明
            ,narhis -- 历史备注信息
            ,inftxt -- 信息文本
            ,coladrblk -- 代收行地址块
            ,docpre -- 被提供的文档
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_clt_op(
            inr -- 光票托收委托托收ID号
            ,resrej -- 拒付的原因
            ,bcgque -- 查询信息
            ,bcgans -- 回答信息
            ,strinf -- 给收单行的信息
            ,intrem -- 备注
            ,selmt -- Swift报文类型
            ,cctfre -- 自由文本
            ,coradrblk -- 汇票受票人地址块
            ,droadrblk -- 付款行地址块
            ,preadrblk -- 托收人/收款人地址块
            ,nobadrblk -- 清算行地址块
            ,dftins -- 单据说明
            ,chgtxt -- 费用文本
            ,intins -- 内部说明
            ,setins -- 结算说明
            ,narhis -- 历史备注信息
            ,inftxt -- 信息文本
            ,coladrblk -- 代收行地址块
            ,docpre -- 被提供的文档
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 光票托收委托托收ID号
    ,nvl(n.resrej, o.resrej) as resrej -- 拒付的原因
    ,nvl(n.bcgque, o.bcgque) as bcgque -- 查询信息
    ,nvl(n.bcgans, o.bcgans) as bcgans -- 回答信息
    ,nvl(n.strinf, o.strinf) as strinf -- 给收单行的信息
    ,nvl(n.intrem, o.intrem) as intrem -- 备注
    ,nvl(n.selmt, o.selmt) as selmt -- Swift报文类型
    ,nvl(n.cctfre, o.cctfre) as cctfre -- 自由文本
    ,nvl(n.coradrblk, o.coradrblk) as coradrblk -- 汇票受票人地址块
    ,nvl(n.droadrblk, o.droadrblk) as droadrblk -- 付款行地址块
    ,nvl(n.preadrblk, o.preadrblk) as preadrblk -- 托收人/收款人地址块
    ,nvl(n.nobadrblk, o.nobadrblk) as nobadrblk -- 清算行地址块
    ,nvl(n.dftins, o.dftins) as dftins -- 单据说明
    ,nvl(n.chgtxt, o.chgtxt) as chgtxt -- 费用文本
    ,nvl(n.intins, o.intins) as intins -- 内部说明
    ,nvl(n.setins, o.setins) as setins -- 结算说明
    ,nvl(n.narhis, o.narhis) as narhis -- 历史备注信息
    ,nvl(n.inftxt, o.inftxt) as inftxt -- 信息文本
    ,nvl(n.coladrblk, o.coladrblk) as coladrblk -- 代收行地址块
    ,nvl(n.docpre, o.docpre) as docpre -- 被提供的文档
    ,case when
            n.inr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_clt_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_clt where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.resrej <> n.resrej
        or o.bcgque <> n.bcgque
        or o.bcgans <> n.bcgans
        or o.strinf <> n.strinf
        or o.intrem <> n.intrem
        or o.selmt <> n.selmt
        or o.cctfre <> n.cctfre
        or o.coradrblk <> n.coradrblk
        or o.droadrblk <> n.droadrblk
        or o.preadrblk <> n.preadrblk
        or o.nobadrblk <> n.nobadrblk
        or o.dftins <> n.dftins
        or o.chgtxt <> n.chgtxt
        or o.intins <> n.intins
        or o.setins <> n.setins
        or o.narhis <> n.narhis
        or o.inftxt <> n.inftxt
        or o.coladrblk <> n.coladrblk
        or o.docpre <> n.docpre
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_clt_cl(
            inr -- 光票托收委托托收ID号
            ,resrej -- 拒付的原因
            ,bcgque -- 查询信息
            ,bcgans -- 回答信息
            ,strinf -- 给收单行的信息
            ,intrem -- 备注
            ,selmt -- Swift报文类型
            ,cctfre -- 自由文本
            ,coradrblk -- 汇票受票人地址块
            ,droadrblk -- 付款行地址块
            ,preadrblk -- 托收人/收款人地址块
            ,nobadrblk -- 清算行地址块
            ,dftins -- 单据说明
            ,chgtxt -- 费用文本
            ,intins -- 内部说明
            ,setins -- 结算说明
            ,narhis -- 历史备注信息
            ,inftxt -- 信息文本
            ,coladrblk -- 代收行地址块
            ,docpre -- 被提供的文档
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_clt_op(
            inr -- 光票托收委托托收ID号
            ,resrej -- 拒付的原因
            ,bcgque -- 查询信息
            ,bcgans -- 回答信息
            ,strinf -- 给收单行的信息
            ,intrem -- 备注
            ,selmt -- Swift报文类型
            ,cctfre -- 自由文本
            ,coradrblk -- 汇票受票人地址块
            ,droadrblk -- 付款行地址块
            ,preadrblk -- 托收人/收款人地址块
            ,nobadrblk -- 清算行地址块
            ,dftins -- 单据说明
            ,chgtxt -- 费用文本
            ,intins -- 内部说明
            ,setins -- 结算说明
            ,narhis -- 历史备注信息
            ,inftxt -- 信息文本
            ,coladrblk -- 代收行地址块
            ,docpre -- 被提供的文档
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 光票托收委托托收ID号
    ,o.resrej -- 拒付的原因
    ,o.bcgque -- 查询信息
    ,o.bcgans -- 回答信息
    ,o.strinf -- 给收单行的信息
    ,o.intrem -- 备注
    ,o.selmt -- Swift报文类型
    ,o.cctfre -- 自由文本
    ,o.coradrblk -- 汇票受票人地址块
    ,o.droadrblk -- 付款行地址块
    ,o.preadrblk -- 托收人/收款人地址块
    ,o.nobadrblk -- 清算行地址块
    ,o.dftins -- 单据说明
    ,o.chgtxt -- 费用文本
    ,o.intins -- 内部说明
    ,o.setins -- 结算说明
    ,o.narhis -- 历史备注信息
    ,o.inftxt -- 信息文本
    ,o.coladrblk -- 代收行地址块
    ,o.docpre -- 被提供的文档
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_clt_bk o
    left join ${iol_schema}.isbs_clt_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_clt_cl d
        on
            o.inr = d.inr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.isbs_clt;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_clt exchange partition p_19000101 with table ${iol_schema}.isbs_clt_cl;
alter table ${iol_schema}.isbs_clt exchange partition p_20991231 with table ${iol_schema}.isbs_clt_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_clt to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_clt_op purge;
drop table ${iol_schema}.isbs_clt_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_clt_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_clt',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
