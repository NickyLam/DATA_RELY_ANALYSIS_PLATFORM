/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_lit
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
create table ${iol_schema}.isbs_lit_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_lit;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_lit_op purge;
drop table ${iol_schema}.isbs_lit_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_lit_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_lit where 0=1;

create table ${iol_schema}.isbs_lit_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_lit where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_lit_cl(
            inr -- 进口信用证ID号
            ,adlcnd -- 附加条款
            ,defdet -- 延期付款细节
            ,dftat -- 票据条款
            ,feetxt -- 手续费
            ,insbnk -- 银行说明
            ,lcrdoc -- 票据说明
            ,lcrgod -- 货物说明
            ,mixdet -- 混合付款细节
            ,preper -- 提示周期
            ,rmbcha -- 偿付行其他费用
            ,shpper -- 装船周期
            ,ver -- 版本号
            ,adlcndame -- 附加环境
            ,lcrgodame -- 货物描述
            ,lcrdocame -- 票据描述
            ,narhis -- 叙述历史
            ,fldmodblk -- LID中修改过的字段列表
            ,revnotes -- 给申请人的信息
            ,revcls -- 循环条款
            ,avbwthtxt -- 处理方式的信息文本
            ,addamtcov -- 增加的保证金
            ,insbnkame -- 记录修改的情况（给paying, accepting, negotiating bank）
            ,contag72 -- 报文72场内容
            ,contag79 -- 报文79场内容
            ,preperdef -- 承兑条款
            ,preperflg -- 承兑期限修改标志
            ,decamtstm -- 金额修改
            ,forins -- 
            ,insdat -- 
            ,othtyp -- 
            ,spcben -- 
            ,spcrcb -- 
            ,spcbename -- 
            ,spcrcbame -- 
            ,xddstm -- 信贷担保信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_lit_op(
            inr -- 进口信用证ID号
            ,adlcnd -- 附加条款
            ,defdet -- 延期付款细节
            ,dftat -- 票据条款
            ,feetxt -- 手续费
            ,insbnk -- 银行说明
            ,lcrdoc -- 票据说明
            ,lcrgod -- 货物说明
            ,mixdet -- 混合付款细节
            ,preper -- 提示周期
            ,rmbcha -- 偿付行其他费用
            ,shpper -- 装船周期
            ,ver -- 版本号
            ,adlcndame -- 附加环境
            ,lcrgodame -- 货物描述
            ,lcrdocame -- 票据描述
            ,narhis -- 叙述历史
            ,fldmodblk -- LID中修改过的字段列表
            ,revnotes -- 给申请人的信息
            ,revcls -- 循环条款
            ,avbwthtxt -- 处理方式的信息文本
            ,addamtcov -- 增加的保证金
            ,insbnkame -- 记录修改的情况（给paying, accepting, negotiating bank）
            ,contag72 -- 报文72场内容
            ,contag79 -- 报文79场内容
            ,preperdef -- 承兑条款
            ,preperflg -- 承兑期限修改标志
            ,decamtstm -- 金额修改
            ,forins -- 
            ,insdat -- 
            ,othtyp -- 
            ,spcben -- 
            ,spcrcb -- 
            ,spcbename -- 
            ,spcrcbame -- 
            ,xddstm -- 信贷担保信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 进口信用证ID号
    ,nvl(n.adlcnd, o.adlcnd) as adlcnd -- 附加条款
    ,nvl(n.defdet, o.defdet) as defdet -- 延期付款细节
    ,nvl(n.dftat, o.dftat) as dftat -- 票据条款
    ,nvl(n.feetxt, o.feetxt) as feetxt -- 手续费
    ,nvl(n.insbnk, o.insbnk) as insbnk -- 银行说明
    ,nvl(n.lcrdoc, o.lcrdoc) as lcrdoc -- 票据说明
    ,nvl(n.lcrgod, o.lcrgod) as lcrgod -- 货物说明
    ,nvl(n.mixdet, o.mixdet) as mixdet -- 混合付款细节
    ,nvl(n.preper, o.preper) as preper -- 提示周期
    ,nvl(n.rmbcha, o.rmbcha) as rmbcha -- 偿付行其他费用
    ,nvl(n.shpper, o.shpper) as shpper -- 装船周期
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.adlcndame, o.adlcndame) as adlcndame -- 附加环境
    ,nvl(n.lcrgodame, o.lcrgodame) as lcrgodame -- 货物描述
    ,nvl(n.lcrdocame, o.lcrdocame) as lcrdocame -- 票据描述
    ,nvl(n.narhis, o.narhis) as narhis -- 叙述历史
    ,nvl(n.fldmodblk, o.fldmodblk) as fldmodblk -- LID中修改过的字段列表
    ,nvl(n.revnotes, o.revnotes) as revnotes -- 给申请人的信息
    ,nvl(n.revcls, o.revcls) as revcls -- 循环条款
    ,nvl(n.avbwthtxt, o.avbwthtxt) as avbwthtxt -- 处理方式的信息文本
    ,nvl(n.addamtcov, o.addamtcov) as addamtcov -- 增加的保证金
    ,nvl(n.insbnkame, o.insbnkame) as insbnkame -- 记录修改的情况（给paying, accepting, negotiating bank）
    ,nvl(n.contag72, o.contag72) as contag72 -- 报文72场内容
    ,nvl(n.contag79, o.contag79) as contag79 -- 报文79场内容
    ,nvl(n.preperdef, o.preperdef) as preperdef -- 承兑条款
    ,nvl(n.preperflg, o.preperflg) as preperflg -- 承兑期限修改标志
    ,nvl(n.decamtstm, o.decamtstm) as decamtstm -- 金额修改
    ,nvl(n.forins, o.forins) as forins -- 
    ,nvl(n.insdat, o.insdat) as insdat -- 
    ,nvl(n.othtyp, o.othtyp) as othtyp -- 
    ,nvl(n.spcben, o.spcben) as spcben -- 
    ,nvl(n.spcrcb, o.spcrcb) as spcrcb -- 
    ,nvl(n.spcbename, o.spcbename) as spcbename -- 
    ,nvl(n.spcrcbame, o.spcrcbame) as spcrcbame -- 
    ,nvl(n.xddstm, o.xddstm) as xddstm -- 信贷担保信息
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
from (select * from ${iol_schema}.isbs_lit_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_lit where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.adlcnd <> n.adlcnd
        or o.defdet <> n.defdet
        or o.dftat <> n.dftat
        or o.feetxt <> n.feetxt
        or o.insbnk <> n.insbnk
        or o.lcrdoc <> n.lcrdoc
        or o.lcrgod <> n.lcrgod
        or o.mixdet <> n.mixdet
        or o.preper <> n.preper
        or o.rmbcha <> n.rmbcha
        or o.shpper <> n.shpper
        or o.ver <> n.ver
        or o.adlcndame <> n.adlcndame
        or o.lcrgodame <> n.lcrgodame
        or o.lcrdocame <> n.lcrdocame
        or o.narhis <> n.narhis
        or o.fldmodblk <> n.fldmodblk
        or o.revnotes <> n.revnotes
        or o.revcls <> n.revcls
        or o.avbwthtxt <> n.avbwthtxt
        or o.addamtcov <> n.addamtcov
        or o.insbnkame <> n.insbnkame
        or o.contag72 <> n.contag72
        or o.contag79 <> n.contag79
        or o.preperdef <> n.preperdef
        or o.preperflg <> n.preperflg
        or o.decamtstm <> n.decamtstm
        or o.forins <> n.forins
        or o.insdat <> n.insdat
        or o.othtyp <> n.othtyp
        or o.spcben <> n.spcben
        or o.spcrcb <> n.spcrcb
        or o.spcbename <> n.spcbename
        or o.spcrcbame <> n.spcrcbame
        or o.xddstm <> n.xddstm
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_lit_cl(
            inr -- 进口信用证ID号
            ,adlcnd -- 附加条款
            ,defdet -- 延期付款细节
            ,dftat -- 票据条款
            ,feetxt -- 手续费
            ,insbnk -- 银行说明
            ,lcrdoc -- 票据说明
            ,lcrgod -- 货物说明
            ,mixdet -- 混合付款细节
            ,preper -- 提示周期
            ,rmbcha -- 偿付行其他费用
            ,shpper -- 装船周期
            ,ver -- 版本号
            ,adlcndame -- 附加环境
            ,lcrgodame -- 货物描述
            ,lcrdocame -- 票据描述
            ,narhis -- 叙述历史
            ,fldmodblk -- LID中修改过的字段列表
            ,revnotes -- 给申请人的信息
            ,revcls -- 循环条款
            ,avbwthtxt -- 处理方式的信息文本
            ,addamtcov -- 增加的保证金
            ,insbnkame -- 记录修改的情况（给paying, accepting, negotiating bank）
            ,contag72 -- 报文72场内容
            ,contag79 -- 报文79场内容
            ,preperdef -- 承兑条款
            ,preperflg -- 承兑期限修改标志
            ,decamtstm -- 金额修改
            ,forins -- 
            ,insdat -- 
            ,othtyp -- 
            ,spcben -- 
            ,spcrcb -- 
            ,spcbename -- 
            ,spcrcbame -- 
            ,xddstm -- 信贷担保信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_lit_op(
            inr -- 进口信用证ID号
            ,adlcnd -- 附加条款
            ,defdet -- 延期付款细节
            ,dftat -- 票据条款
            ,feetxt -- 手续费
            ,insbnk -- 银行说明
            ,lcrdoc -- 票据说明
            ,lcrgod -- 货物说明
            ,mixdet -- 混合付款细节
            ,preper -- 提示周期
            ,rmbcha -- 偿付行其他费用
            ,shpper -- 装船周期
            ,ver -- 版本号
            ,adlcndame -- 附加环境
            ,lcrgodame -- 货物描述
            ,lcrdocame -- 票据描述
            ,narhis -- 叙述历史
            ,fldmodblk -- LID中修改过的字段列表
            ,revnotes -- 给申请人的信息
            ,revcls -- 循环条款
            ,avbwthtxt -- 处理方式的信息文本
            ,addamtcov -- 增加的保证金
            ,insbnkame -- 记录修改的情况（给paying, accepting, negotiating bank）
            ,contag72 -- 报文72场内容
            ,contag79 -- 报文79场内容
            ,preperdef -- 承兑条款
            ,preperflg -- 承兑期限修改标志
            ,decamtstm -- 金额修改
            ,forins -- 
            ,insdat -- 
            ,othtyp -- 
            ,spcben -- 
            ,spcrcb -- 
            ,spcbename -- 
            ,spcrcbame -- 
            ,xddstm -- 信贷担保信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 进口信用证ID号
    ,o.adlcnd -- 附加条款
    ,o.defdet -- 延期付款细节
    ,o.dftat -- 票据条款
    ,o.feetxt -- 手续费
    ,o.insbnk -- 银行说明
    ,o.lcrdoc -- 票据说明
    ,o.lcrgod -- 货物说明
    ,o.mixdet -- 混合付款细节
    ,o.preper -- 提示周期
    ,o.rmbcha -- 偿付行其他费用
    ,o.shpper -- 装船周期
    ,o.ver -- 版本号
    ,o.adlcndame -- 附加环境
    ,o.lcrgodame -- 货物描述
    ,o.lcrdocame -- 票据描述
    ,o.narhis -- 叙述历史
    ,o.fldmodblk -- LID中修改过的字段列表
    ,o.revnotes -- 给申请人的信息
    ,o.revcls -- 循环条款
    ,o.avbwthtxt -- 处理方式的信息文本
    ,o.addamtcov -- 增加的保证金
    ,o.insbnkame -- 记录修改的情况（给paying, accepting, negotiating bank）
    ,o.contag72 -- 报文72场内容
    ,o.contag79 -- 报文79场内容
    ,o.preperdef -- 承兑条款
    ,o.preperflg -- 承兑期限修改标志
    ,o.decamtstm -- 金额修改
    ,o.forins -- 
    ,o.insdat -- 
    ,o.othtyp -- 
    ,o.spcben -- 
    ,o.spcrcb -- 
    ,o.spcbename -- 
    ,o.spcrcbame -- 
    ,o.xddstm -- 信贷担保信息
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_lit_bk o
    left join ${iol_schema}.isbs_lit_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_lit_cl d
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
-- truncate table ${iol_schema}.isbs_lit;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_lit exchange partition p_19000101 with table ${iol_schema}.isbs_lit_cl;
alter table ${iol_schema}.isbs_lit exchange partition p_20991231 with table ${iol_schema}.isbs_lit_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_lit to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_lit_op purge;
drop table ${iol_schema}.isbs_lit_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_lit_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_lit',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
