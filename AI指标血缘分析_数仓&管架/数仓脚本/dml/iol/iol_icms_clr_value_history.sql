/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_value_history
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
create table ${iol_schema}.icms_clr_value_history_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_value_history
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_value_history_op purge;
drop table ${iol_schema}.icms_clr_value_history_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_value_history_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_value_history where 0=1;

create table ${iol_schema}.icms_clr_value_history_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_value_history where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_value_history_cl(
            serialno -- 价值记录流水号
            ,clrid -- 押品编号
            ,evalmode -- 评估方式（01-外部评估、02-内部评估、03-内外部综合评估）
            ,evaldate -- 估值日期
            ,curreny -- 币种
            ,rate -- 汇率
            ,outevalexpdate -- 外部评估价值估值到期日期
            ,outevaldeptcode -- 外部评估机构
            ,outevalmethod -- 外部评估方法（01-指数法_外部指数、02-指数法_内部构建指数、03-市场法、04-收益法、05-重置成本法、06-工程进度法、07-非上市公司股权净资产比例法、08-直接引用法_金融质抵质押品、09-直接引用法_动产、10-直接引用法_房地产、11-直接引用法_询价、12-其他）
            ,outevalflag -- 是否有外部预评估报告（0-否、1-是）
            ,outevalamt1 -- 外部预评估报告的评估价值
            ,outevaldate -- 外部正式评估报告评估日期
            ,outevalamt -- 外部正式评估报告的评估价值
            ,evalamt -- 内部评估价值
            ,evalamt2 -- 申请评估确认价值
            ,businessinsid -- 流程编号（我行确认价值对应的流程编号，如我行确认价值为自动重估得到，则该字段为空）
            ,confmamt -- 我行确认价值
            ,condate -- 评估认定日期
            ,firstoutevalamt -- 初评外部正式评估价值
            ,firstevalamt -- 初评内部评估价值
            ,firstconfmamt -- 初评我行确认价值
            ,startbusinessinsid -- 初评流程编号
            ,verecoginition -- 押品价值认定方式
            ,outevalstatus -- 准入状态（01-未准入、02-已准入、03-黑名单、04-已退出、05-已取消）
            ,outevalextcustcname -- 外部评估机构名称
            ,slflag -- 是否世联评估
            ,isaccurateprice -- 是否精准价(1是【按照楼盘id+楼栋id+房号编码+面积，世联返回的价格】 0否【世联返回均价】
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,autooutevalamt -- 世联评估价值
            ,autooutevalamt2 -- 房讯通评估价值
            ,outevaldeptcode2 -- 外部评估机构2
            ,outevalamt2 -- 外部正式评估报告的评估价值2
            ,outevaldate2 -- 外部评估基准日2
            ,outevalflag2 -- 是否有外部评估报告2
            ,outevalstartdate2 -- 外部评估价值有效期起始日2
            ,outevalexpdate2 -- 外部评估价值有效期截止日2
            ,confmdeptcode -- 最终选定外部评估机构
            ,calculateflag -- 测算标识
            ,accoutingamt -- 记账价值
            ,accoutingorgid -- 记账机构
            ,outevalstartdate -- 外部评估价值有效期起始日
            ,isvaluechange -- 是否变更我行确认价值
            ,slcaseid -- 世联估值案例编号
            ,fxtcaseid -- 房讯通估值案例编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_value_history_op(
            serialno -- 价值记录流水号
            ,clrid -- 押品编号
            ,evalmode -- 评估方式（01-外部评估、02-内部评估、03-内外部综合评估）
            ,evaldate -- 估值日期
            ,curreny -- 币种
            ,rate -- 汇率
            ,outevalexpdate -- 外部评估价值估值到期日期
            ,outevaldeptcode -- 外部评估机构
            ,outevalmethod -- 外部评估方法（01-指数法_外部指数、02-指数法_内部构建指数、03-市场法、04-收益法、05-重置成本法、06-工程进度法、07-非上市公司股权净资产比例法、08-直接引用法_金融质抵质押品、09-直接引用法_动产、10-直接引用法_房地产、11-直接引用法_询价、12-其他）
            ,outevalflag -- 是否有外部预评估报告（0-否、1-是）
            ,outevalamt1 -- 外部预评估报告的评估价值
            ,outevaldate -- 外部正式评估报告评估日期
            ,outevalamt -- 外部正式评估报告的评估价值
            ,evalamt -- 内部评估价值
            ,evalamt2 -- 申请评估确认价值
            ,businessinsid -- 流程编号（我行确认价值对应的流程编号，如我行确认价值为自动重估得到，则该字段为空）
            ,confmamt -- 我行确认价值
            ,condate -- 评估认定日期
            ,firstoutevalamt -- 初评外部正式评估价值
            ,firstevalamt -- 初评内部评估价值
            ,firstconfmamt -- 初评我行确认价值
            ,startbusinessinsid -- 初评流程编号
            ,verecoginition -- 押品价值认定方式
            ,outevalstatus -- 准入状态（01-未准入、02-已准入、03-黑名单、04-已退出、05-已取消）
            ,outevalextcustcname -- 外部评估机构名称
            ,slflag -- 是否世联评估
            ,isaccurateprice -- 是否精准价(1是【按照楼盘id+楼栋id+房号编码+面积，世联返回的价格】 0否【世联返回均价】
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,autooutevalamt -- 世联评估价值
            ,autooutevalamt2 -- 房讯通评估价值
            ,outevaldeptcode2 -- 外部评估机构2
            ,outevalamt2 -- 外部正式评估报告的评估价值2
            ,outevaldate2 -- 外部评估基准日2
            ,outevalflag2 -- 是否有外部评估报告2
            ,outevalstartdate2 -- 外部评估价值有效期起始日2
            ,outevalexpdate2 -- 外部评估价值有效期截止日2
            ,confmdeptcode -- 最终选定外部评估机构
            ,calculateflag -- 测算标识
            ,accoutingamt -- 记账价值
            ,accoutingorgid -- 记账机构
            ,outevalstartdate -- 外部评估价值有效期起始日
            ,isvaluechange -- 是否变更我行确认价值
            ,slcaseid -- 世联估值案例编号
            ,fxtcaseid -- 房讯通估值案例编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 价值记录流水号
    ,nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.evalmode, o.evalmode) as evalmode -- 评估方式（01-外部评估、02-内部评估、03-内外部综合评估）
    ,nvl(n.evaldate, o.evaldate) as evaldate -- 估值日期
    ,nvl(n.curreny, o.curreny) as curreny -- 币种
    ,nvl(n.rate, o.rate) as rate -- 汇率
    ,nvl(n.outevalexpdate, o.outevalexpdate) as outevalexpdate -- 外部评估价值估值到期日期
    ,nvl(n.outevaldeptcode, o.outevaldeptcode) as outevaldeptcode -- 外部评估机构
    ,nvl(n.outevalmethod, o.outevalmethod) as outevalmethod -- 外部评估方法（01-指数法_外部指数、02-指数法_内部构建指数、03-市场法、04-收益法、05-重置成本法、06-工程进度法、07-非上市公司股权净资产比例法、08-直接引用法_金融质抵质押品、09-直接引用法_动产、10-直接引用法_房地产、11-直接引用法_询价、12-其他）
    ,nvl(n.outevalflag, o.outevalflag) as outevalflag -- 是否有外部预评估报告（0-否、1-是）
    ,nvl(n.outevalamt1, o.outevalamt1) as outevalamt1 -- 外部预评估报告的评估价值
    ,nvl(n.outevaldate, o.outevaldate) as outevaldate -- 外部正式评估报告评估日期
    ,nvl(n.outevalamt, o.outevalamt) as outevalamt -- 外部正式评估报告的评估价值
    ,nvl(n.evalamt, o.evalamt) as evalamt -- 内部评估价值
    ,nvl(n.evalamt2, o.evalamt2) as evalamt2 -- 申请评估确认价值
    ,nvl(n.businessinsid, o.businessinsid) as businessinsid -- 流程编号（我行确认价值对应的流程编号，如我行确认价值为自动重估得到，则该字段为空）
    ,nvl(n.confmamt, o.confmamt) as confmamt -- 我行确认价值
    ,nvl(n.condate, o.condate) as condate -- 评估认定日期
    ,nvl(n.firstoutevalamt, o.firstoutevalamt) as firstoutevalamt -- 初评外部正式评估价值
    ,nvl(n.firstevalamt, o.firstevalamt) as firstevalamt -- 初评内部评估价值
    ,nvl(n.firstconfmamt, o.firstconfmamt) as firstconfmamt -- 初评我行确认价值
    ,nvl(n.startbusinessinsid, o.startbusinessinsid) as startbusinessinsid -- 初评流程编号
    ,nvl(n.verecoginition, o.verecoginition) as verecoginition -- 押品价值认定方式
    ,nvl(n.outevalstatus, o.outevalstatus) as outevalstatus -- 准入状态（01-未准入、02-已准入、03-黑名单、04-已退出、05-已取消）
    ,nvl(n.outevalextcustcname, o.outevalextcustcname) as outevalextcustcname -- 外部评估机构名称
    ,nvl(n.slflag, o.slflag) as slflag -- 是否世联评估
    ,nvl(n.isaccurateprice, o.isaccurateprice) as isaccurateprice -- 是否精准价(1是【按照楼盘id+楼栋id+房号编码+面积，世联返回的价格】 0否【世联返回均价】
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
    ,nvl(n.autooutevalamt, o.autooutevalamt) as autooutevalamt -- 世联评估价值
    ,nvl(n.autooutevalamt2, o.autooutevalamt2) as autooutevalamt2 -- 房讯通评估价值
    ,nvl(n.outevaldeptcode2, o.outevaldeptcode2) as outevaldeptcode2 -- 外部评估机构2
    ,nvl(n.outevalamt2, o.outevalamt2) as outevalamt2 -- 外部正式评估报告的评估价值2
    ,nvl(n.outevaldate2, o.outevaldate2) as outevaldate2 -- 外部评估基准日2
    ,nvl(n.outevalflag2, o.outevalflag2) as outevalflag2 -- 是否有外部评估报告2
    ,nvl(n.outevalstartdate2, o.outevalstartdate2) as outevalstartdate2 -- 外部评估价值有效期起始日2
    ,nvl(n.outevalexpdate2, o.outevalexpdate2) as outevalexpdate2 -- 外部评估价值有效期截止日2
    ,nvl(n.confmdeptcode, o.confmdeptcode) as confmdeptcode -- 最终选定外部评估机构
    ,nvl(n.calculateflag, o.calculateflag) as calculateflag -- 测算标识
    ,nvl(n.accoutingamt, o.accoutingamt) as accoutingamt -- 记账价值
    ,nvl(n.accoutingorgid, o.accoutingorgid) as accoutingorgid -- 记账机构
    ,nvl(n.outevalstartdate, o.outevalstartdate) as outevalstartdate -- 外部评估价值有效期起始日
    ,nvl(n.isvaluechange, o.isvaluechange) as isvaluechange -- 是否变更我行确认价值
    ,nvl(n.slcaseid, o.slcaseid) as slcaseid -- 世联估值案例编号
    ,nvl(n.fxtcaseid, o.fxtcaseid) as fxtcaseid -- 房讯通估值案例编号
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
from (select * from ${iol_schema}.icms_clr_value_history_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_value_history where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.clrid <> n.clrid
        or o.evalmode <> n.evalmode
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
        or o.condate <> n.condate
        or o.firstoutevalamt <> n.firstoutevalamt
        or o.firstevalamt <> n.firstevalamt
        or o.firstconfmamt <> n.firstconfmamt
        or o.startbusinessinsid <> n.startbusinessinsid
        or o.verecoginition <> n.verecoginition
        or o.outevalstatus <> n.outevalstatus
        or o.outevalextcustcname <> n.outevalextcustcname
        or o.slflag <> n.slflag
        or o.isaccurateprice <> n.isaccurateprice
        or o.migtflag <> n.migtflag
        or o.autooutevalamt <> n.autooutevalamt
        or o.autooutevalamt2 <> n.autooutevalamt2
        or o.outevaldeptcode2 <> n.outevaldeptcode2
        or o.outevalamt2 <> n.outevalamt2
        or o.outevaldate2 <> n.outevaldate2
        or o.outevalflag2 <> n.outevalflag2
        or o.outevalstartdate2 <> n.outevalstartdate2
        or o.outevalexpdate2 <> n.outevalexpdate2
        or o.confmdeptcode <> n.confmdeptcode
        or o.calculateflag <> n.calculateflag
        or o.accoutingamt <> n.accoutingamt
        or o.accoutingorgid <> n.accoutingorgid
        or o.outevalstartdate <> n.outevalstartdate
        or o.isvaluechange <> n.isvaluechange
        or o.slcaseid <> n.slcaseid
        or o.fxtcaseid <> n.fxtcaseid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_value_history_cl(
            serialno -- 价值记录流水号
            ,clrid -- 押品编号
            ,evalmode -- 评估方式（01-外部评估、02-内部评估、03-内外部综合评估）
            ,evaldate -- 估值日期
            ,curreny -- 币种
            ,rate -- 汇率
            ,outevalexpdate -- 外部评估价值估值到期日期
            ,outevaldeptcode -- 外部评估机构
            ,outevalmethod -- 外部评估方法（01-指数法_外部指数、02-指数法_内部构建指数、03-市场法、04-收益法、05-重置成本法、06-工程进度法、07-非上市公司股权净资产比例法、08-直接引用法_金融质抵质押品、09-直接引用法_动产、10-直接引用法_房地产、11-直接引用法_询价、12-其他）
            ,outevalflag -- 是否有外部预评估报告（0-否、1-是）
            ,outevalamt1 -- 外部预评估报告的评估价值
            ,outevaldate -- 外部正式评估报告评估日期
            ,outevalamt -- 外部正式评估报告的评估价值
            ,evalamt -- 内部评估价值
            ,evalamt2 -- 申请评估确认价值
            ,businessinsid -- 流程编号（我行确认价值对应的流程编号，如我行确认价值为自动重估得到，则该字段为空）
            ,confmamt -- 我行确认价值
            ,condate -- 评估认定日期
            ,firstoutevalamt -- 初评外部正式评估价值
            ,firstevalamt -- 初评内部评估价值
            ,firstconfmamt -- 初评我行确认价值
            ,startbusinessinsid -- 初评流程编号
            ,verecoginition -- 押品价值认定方式
            ,outevalstatus -- 准入状态（01-未准入、02-已准入、03-黑名单、04-已退出、05-已取消）
            ,outevalextcustcname -- 外部评估机构名称
            ,slflag -- 是否世联评估
            ,isaccurateprice -- 是否精准价(1是【按照楼盘id+楼栋id+房号编码+面积，世联返回的价格】 0否【世联返回均价】
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,autooutevalamt -- 世联评估价值
            ,autooutevalamt2 -- 房讯通评估价值
            ,outevaldeptcode2 -- 外部评估机构2
            ,outevalamt2 -- 外部正式评估报告的评估价值2
            ,outevaldate2 -- 外部评估基准日2
            ,outevalflag2 -- 是否有外部评估报告2
            ,outevalstartdate2 -- 外部评估价值有效期起始日2
            ,outevalexpdate2 -- 外部评估价值有效期截止日2
            ,confmdeptcode -- 最终选定外部评估机构
            ,calculateflag -- 测算标识
            ,accoutingamt -- 记账价值
            ,accoutingorgid -- 记账机构
            ,outevalstartdate -- 外部评估价值有效期起始日
            ,isvaluechange -- 是否变更我行确认价值
            ,slcaseid -- 世联估值案例编号
            ,fxtcaseid -- 房讯通估值案例编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_value_history_op(
            serialno -- 价值记录流水号
            ,clrid -- 押品编号
            ,evalmode -- 评估方式（01-外部评估、02-内部评估、03-内外部综合评估）
            ,evaldate -- 估值日期
            ,curreny -- 币种
            ,rate -- 汇率
            ,outevalexpdate -- 外部评估价值估值到期日期
            ,outevaldeptcode -- 外部评估机构
            ,outevalmethod -- 外部评估方法（01-指数法_外部指数、02-指数法_内部构建指数、03-市场法、04-收益法、05-重置成本法、06-工程进度法、07-非上市公司股权净资产比例法、08-直接引用法_金融质抵质押品、09-直接引用法_动产、10-直接引用法_房地产、11-直接引用法_询价、12-其他）
            ,outevalflag -- 是否有外部预评估报告（0-否、1-是）
            ,outevalamt1 -- 外部预评估报告的评估价值
            ,outevaldate -- 外部正式评估报告评估日期
            ,outevalamt -- 外部正式评估报告的评估价值
            ,evalamt -- 内部评估价值
            ,evalamt2 -- 申请评估确认价值
            ,businessinsid -- 流程编号（我行确认价值对应的流程编号，如我行确认价值为自动重估得到，则该字段为空）
            ,confmamt -- 我行确认价值
            ,condate -- 评估认定日期
            ,firstoutevalamt -- 初评外部正式评估价值
            ,firstevalamt -- 初评内部评估价值
            ,firstconfmamt -- 初评我行确认价值
            ,startbusinessinsid -- 初评流程编号
            ,verecoginition -- 押品价值认定方式
            ,outevalstatus -- 准入状态（01-未准入、02-已准入、03-黑名单、04-已退出、05-已取消）
            ,outevalextcustcname -- 外部评估机构名称
            ,slflag -- 是否世联评估
            ,isaccurateprice -- 是否精准价(1是【按照楼盘id+楼栋id+房号编码+面积，世联返回的价格】 0否【世联返回均价】
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,autooutevalamt -- 世联评估价值
            ,autooutevalamt2 -- 房讯通评估价值
            ,outevaldeptcode2 -- 外部评估机构2
            ,outevalamt2 -- 外部正式评估报告的评估价值2
            ,outevaldate2 -- 外部评估基准日2
            ,outevalflag2 -- 是否有外部评估报告2
            ,outevalstartdate2 -- 外部评估价值有效期起始日2
            ,outevalexpdate2 -- 外部评估价值有效期截止日2
            ,confmdeptcode -- 最终选定外部评估机构
            ,calculateflag -- 测算标识
            ,accoutingamt -- 记账价值
            ,accoutingorgid -- 记账机构
            ,outevalstartdate -- 外部评估价值有效期起始日
            ,isvaluechange -- 是否变更我行确认价值
            ,slcaseid -- 世联估值案例编号
            ,fxtcaseid -- 房讯通估值案例编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 价值记录流水号
    ,o.clrid -- 押品编号
    ,o.evalmode -- 评估方式（01-外部评估、02-内部评估、03-内外部综合评估）
    ,o.evaldate -- 估值日期
    ,o.curreny -- 币种
    ,o.rate -- 汇率
    ,o.outevalexpdate -- 外部评估价值估值到期日期
    ,o.outevaldeptcode -- 外部评估机构
    ,o.outevalmethod -- 外部评估方法（01-指数法_外部指数、02-指数法_内部构建指数、03-市场法、04-收益法、05-重置成本法、06-工程进度法、07-非上市公司股权净资产比例法、08-直接引用法_金融质抵质押品、09-直接引用法_动产、10-直接引用法_房地产、11-直接引用法_询价、12-其他）
    ,o.outevalflag -- 是否有外部预评估报告（0-否、1-是）
    ,o.outevalamt1 -- 外部预评估报告的评估价值
    ,o.outevaldate -- 外部正式评估报告评估日期
    ,o.outevalamt -- 外部正式评估报告的评估价值
    ,o.evalamt -- 内部评估价值
    ,o.evalamt2 -- 申请评估确认价值
    ,o.businessinsid -- 流程编号（我行确认价值对应的流程编号，如我行确认价值为自动重估得到，则该字段为空）
    ,o.confmamt -- 我行确认价值
    ,o.condate -- 评估认定日期
    ,o.firstoutevalamt -- 初评外部正式评估价值
    ,o.firstevalamt -- 初评内部评估价值
    ,o.firstconfmamt -- 初评我行确认价值
    ,o.startbusinessinsid -- 初评流程编号
    ,o.verecoginition -- 押品价值认定方式
    ,o.outevalstatus -- 准入状态（01-未准入、02-已准入、03-黑名单、04-已退出、05-已取消）
    ,o.outevalextcustcname -- 外部评估机构名称
    ,o.slflag -- 是否世联评估
    ,o.isaccurateprice -- 是否精准价(1是【按照楼盘id+楼栋id+房号编码+面积，世联返回的价格】 0否【世联返回均价】
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
    ,o.autooutevalamt -- 世联评估价值
    ,o.autooutevalamt2 -- 房讯通评估价值
    ,o.outevaldeptcode2 -- 外部评估机构2
    ,o.outevalamt2 -- 外部正式评估报告的评估价值2
    ,o.outevaldate2 -- 外部评估基准日2
    ,o.outevalflag2 -- 是否有外部评估报告2
    ,o.outevalstartdate2 -- 外部评估价值有效期起始日2
    ,o.outevalexpdate2 -- 外部评估价值有效期截止日2
    ,o.confmdeptcode -- 最终选定外部评估机构
    ,o.calculateflag -- 测算标识
    ,o.accoutingamt -- 记账价值
    ,o.accoutingorgid -- 记账机构
    ,o.outevalstartdate -- 外部评估价值有效期起始日
    ,o.isvaluechange -- 是否变更我行确认价值
    ,o.slcaseid -- 世联估值案例编号
    ,o.fxtcaseid -- 房讯通估值案例编号
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
from ${iol_schema}.icms_clr_value_history_bk o
    left join ${iol_schema}.icms_clr_value_history_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_value_history_cl d
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
--truncate table ${iol_schema}.icms_clr_value_history;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_value_history') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_value_history drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_value_history add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_value_history exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_value_history_cl;
alter table ${iol_schema}.icms_clr_value_history exchange partition p_20991231 with table ${iol_schema}.icms_clr_value_history_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_value_history to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_value_history_op purge;
drop table ${iol_schema}.icms_clr_value_history_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_value_history_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_value_history',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
