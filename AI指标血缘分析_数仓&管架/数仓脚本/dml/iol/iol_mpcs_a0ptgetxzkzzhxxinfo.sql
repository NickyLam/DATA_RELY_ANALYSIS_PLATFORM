/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0ptgetxzkzzhxxinfo
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
create table ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo_op purge;
drop table ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo where 0=1;

create table ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo_cl(
            transdt -- 交易日期
            ,transtm -- 交易时间
            ,uptdttm -- 更新时间
            ,diskno -- 批次号
            ,bdhm -- 控制请求单号
            ,ccxh -- 序号
            ,khzh -- 开户账号
            ,cclb -- 账户类别
            ,khwd -- 开户网点
            ,khwddm -- 开户网点代码
            ,bz -- 申请控制金额币种
            ,kzlx -- 控制类型 1-存款 2-非存款类金融资产
            ,kzcs -- 控制措施 01 冻结02 继续冻结 03 轮候冻结 04 解除冻结 05 解除轮候冻结 06 划拨 07 提取收入 08 冻结并划拨
            ,glzhhm -- 开户账号子账号
            ,zcmc -- 金融资产名称
            ,zclx -- 金融资产类型
            ,jldw -- 计量单位
            ,kznr -- 申请控制内容 1-账户下的资金 2-账户
            ,ksrq -- 申请控制开始日期
            ,jsrq -- 申请控制结束日期
            ,je -- 申请控制金额
            ,sfjh -- 是否结汇
            ,ckwh -- 裁定文书号
            ,zxkzhhm -- 执行款专户户名
            ,zxkzhkhh -- 执行款专户开户行
            ,zxkzhkhhhh -- 执行款专户开户行行号
            ,zxkzhzh -- 执行款专户账号
            ,zxkzhlx -- 执行款专户类型
            ,ydjah -- 原冻结案号
            ,ydjdh -- 原冻结请求单单号
            ,result -- 处理状态 0-录入 1-已处理 2-处理失败 3-已登记
            ,cpxszl -- 产品销售种类
            ,dqh -- 地区号
            ,jrcpbh -- 金融产品编号
            ,lczh -- 理财账号
            ,zjhkzh -- 资金回款账户
            ,se -- 申请控制数量/份额/金额
            ,jrkzflag -- 金融产品冻结标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo_op(
            transdt -- 交易日期
            ,transtm -- 交易时间
            ,uptdttm -- 更新时间
            ,diskno -- 批次号
            ,bdhm -- 控制请求单号
            ,ccxh -- 序号
            ,khzh -- 开户账号
            ,cclb -- 账户类别
            ,khwd -- 开户网点
            ,khwddm -- 开户网点代码
            ,bz -- 申请控制金额币种
            ,kzlx -- 控制类型 1-存款 2-非存款类金融资产
            ,kzcs -- 控制措施 01 冻结02 继续冻结 03 轮候冻结 04 解除冻结 05 解除轮候冻结 06 划拨 07 提取收入 08 冻结并划拨
            ,glzhhm -- 开户账号子账号
            ,zcmc -- 金融资产名称
            ,zclx -- 金融资产类型
            ,jldw -- 计量单位
            ,kznr -- 申请控制内容 1-账户下的资金 2-账户
            ,ksrq -- 申请控制开始日期
            ,jsrq -- 申请控制结束日期
            ,je -- 申请控制金额
            ,sfjh -- 是否结汇
            ,ckwh -- 裁定文书号
            ,zxkzhhm -- 执行款专户户名
            ,zxkzhkhh -- 执行款专户开户行
            ,zxkzhkhhhh -- 执行款专户开户行行号
            ,zxkzhzh -- 执行款专户账号
            ,zxkzhlx -- 执行款专户类型
            ,ydjah -- 原冻结案号
            ,ydjdh -- 原冻结请求单单号
            ,result -- 处理状态 0-录入 1-已处理 2-处理失败 3-已登记
            ,cpxszl -- 产品销售种类
            ,dqh -- 地区号
            ,jrcpbh -- 金融产品编号
            ,lczh -- 理财账号
            ,zjhkzh -- 资金回款账户
            ,se -- 申请控制数量/份额/金额
            ,jrkzflag -- 金融产品冻结标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.transdt, o.transdt) as transdt -- 交易日期
    ,nvl(n.transtm, o.transtm) as transtm -- 交易时间
    ,nvl(n.uptdttm, o.uptdttm) as uptdttm -- 更新时间
    ,nvl(n.diskno, o.diskno) as diskno -- 批次号
    ,nvl(n.bdhm, o.bdhm) as bdhm -- 控制请求单号
    ,nvl(n.ccxh, o.ccxh) as ccxh -- 序号
    ,nvl(n.khzh, o.khzh) as khzh -- 开户账号
    ,nvl(n.cclb, o.cclb) as cclb -- 账户类别
    ,nvl(n.khwd, o.khwd) as khwd -- 开户网点
    ,nvl(n.khwddm, o.khwddm) as khwddm -- 开户网点代码
    ,nvl(n.bz, o.bz) as bz -- 申请控制金额币种
    ,nvl(n.kzlx, o.kzlx) as kzlx -- 控制类型 1-存款 2-非存款类金融资产
    ,nvl(n.kzcs, o.kzcs) as kzcs -- 控制措施 01 冻结02 继续冻结 03 轮候冻结 04 解除冻结 05 解除轮候冻结 06 划拨 07 提取收入 08 冻结并划拨
    ,nvl(n.glzhhm, o.glzhhm) as glzhhm -- 开户账号子账号
    ,nvl(n.zcmc, o.zcmc) as zcmc -- 金融资产名称
    ,nvl(n.zclx, o.zclx) as zclx -- 金融资产类型
    ,nvl(n.jldw, o.jldw) as jldw -- 计量单位
    ,nvl(n.kznr, o.kznr) as kznr -- 申请控制内容 1-账户下的资金 2-账户
    ,nvl(n.ksrq, o.ksrq) as ksrq -- 申请控制开始日期
    ,nvl(n.jsrq, o.jsrq) as jsrq -- 申请控制结束日期
    ,nvl(n.je, o.je) as je -- 申请控制金额
    ,nvl(n.sfjh, o.sfjh) as sfjh -- 是否结汇
    ,nvl(n.ckwh, o.ckwh) as ckwh -- 裁定文书号
    ,nvl(n.zxkzhhm, o.zxkzhhm) as zxkzhhm -- 执行款专户户名
    ,nvl(n.zxkzhkhh, o.zxkzhkhh) as zxkzhkhh -- 执行款专户开户行
    ,nvl(n.zxkzhkhhhh, o.zxkzhkhhhh) as zxkzhkhhhh -- 执行款专户开户行行号
    ,nvl(n.zxkzhzh, o.zxkzhzh) as zxkzhzh -- 执行款专户账号
    ,nvl(n.zxkzhlx, o.zxkzhlx) as zxkzhlx -- 执行款专户类型
    ,nvl(n.ydjah, o.ydjah) as ydjah -- 原冻结案号
    ,nvl(n.ydjdh, o.ydjdh) as ydjdh -- 原冻结请求单单号
    ,nvl(n.result, o.result) as result -- 处理状态 0-录入 1-已处理 2-处理失败 3-已登记
    ,nvl(n.cpxszl, o.cpxszl) as cpxszl -- 产品销售种类
    ,nvl(n.dqh, o.dqh) as dqh -- 地区号
    ,nvl(n.jrcpbh, o.jrcpbh) as jrcpbh -- 金融产品编号
    ,nvl(n.lczh, o.lczh) as lczh -- 理财账号
    ,nvl(n.zjhkzh, o.zjhkzh) as zjhkzh -- 资金回款账户
    ,nvl(n.se, o.se) as se -- 申请控制数量/份额/金额
    ,nvl(n.jrkzflag, o.jrkzflag) as jrkzflag -- 金融产品冻结标志
    ,case when
            n.bdhm is null
            and n.ccxh is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bdhm is null
            and n.ccxh is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bdhm is null
            and n.ccxh is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a0ptgetxzkzzhxxinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bdhm = n.bdhm
            and o.ccxh = n.ccxh
where (
        o.bdhm is null
        and o.ccxh is null
    )
    or (
        n.bdhm is null
        and n.ccxh is null
    )
    or (
        o.transdt <> n.transdt
        or o.transtm <> n.transtm
        or o.uptdttm <> n.uptdttm
        or o.diskno <> n.diskno
        or o.khzh <> n.khzh
        or o.cclb <> n.cclb
        or o.khwd <> n.khwd
        or o.khwddm <> n.khwddm
        or o.bz <> n.bz
        or o.kzlx <> n.kzlx
        or o.kzcs <> n.kzcs
        or o.glzhhm <> n.glzhhm
        or o.zcmc <> n.zcmc
        or o.zclx <> n.zclx
        or o.jldw <> n.jldw
        or o.kznr <> n.kznr
        or o.ksrq <> n.ksrq
        or o.jsrq <> n.jsrq
        or o.je <> n.je
        or o.sfjh <> n.sfjh
        or o.ckwh <> n.ckwh
        or o.zxkzhhm <> n.zxkzhhm
        or o.zxkzhkhh <> n.zxkzhkhh
        or o.zxkzhkhhhh <> n.zxkzhkhhhh
        or o.zxkzhzh <> n.zxkzhzh
        or o.zxkzhlx <> n.zxkzhlx
        or o.ydjah <> n.ydjah
        or o.ydjdh <> n.ydjdh
        or o.result <> n.result
        or o.cpxszl <> n.cpxszl
        or o.dqh <> n.dqh
        or o.jrcpbh <> n.jrcpbh
        or o.lczh <> n.lczh
        or o.zjhkzh <> n.zjhkzh
        or o.se <> n.se
        or o.jrkzflag <> n.jrkzflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo_cl(
            transdt -- 交易日期
            ,transtm -- 交易时间
            ,uptdttm -- 更新时间
            ,diskno -- 批次号
            ,bdhm -- 控制请求单号
            ,ccxh -- 序号
            ,khzh -- 开户账号
            ,cclb -- 账户类别
            ,khwd -- 开户网点
            ,khwddm -- 开户网点代码
            ,bz -- 申请控制金额币种
            ,kzlx -- 控制类型 1-存款 2-非存款类金融资产
            ,kzcs -- 控制措施 01 冻结02 继续冻结 03 轮候冻结 04 解除冻结 05 解除轮候冻结 06 划拨 07 提取收入 08 冻结并划拨
            ,glzhhm -- 开户账号子账号
            ,zcmc -- 金融资产名称
            ,zclx -- 金融资产类型
            ,jldw -- 计量单位
            ,kznr -- 申请控制内容 1-账户下的资金 2-账户
            ,ksrq -- 申请控制开始日期
            ,jsrq -- 申请控制结束日期
            ,je -- 申请控制金额
            ,sfjh -- 是否结汇
            ,ckwh -- 裁定文书号
            ,zxkzhhm -- 执行款专户户名
            ,zxkzhkhh -- 执行款专户开户行
            ,zxkzhkhhhh -- 执行款专户开户行行号
            ,zxkzhzh -- 执行款专户账号
            ,zxkzhlx -- 执行款专户类型
            ,ydjah -- 原冻结案号
            ,ydjdh -- 原冻结请求单单号
            ,result -- 处理状态 0-录入 1-已处理 2-处理失败 3-已登记
            ,cpxszl -- 产品销售种类
            ,dqh -- 地区号
            ,jrcpbh -- 金融产品编号
            ,lczh -- 理财账号
            ,zjhkzh -- 资金回款账户
            ,se -- 申请控制数量/份额/金额
            ,jrkzflag -- 金融产品冻结标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo_op(
            transdt -- 交易日期
            ,transtm -- 交易时间
            ,uptdttm -- 更新时间
            ,diskno -- 批次号
            ,bdhm -- 控制请求单号
            ,ccxh -- 序号
            ,khzh -- 开户账号
            ,cclb -- 账户类别
            ,khwd -- 开户网点
            ,khwddm -- 开户网点代码
            ,bz -- 申请控制金额币种
            ,kzlx -- 控制类型 1-存款 2-非存款类金融资产
            ,kzcs -- 控制措施 01 冻结02 继续冻结 03 轮候冻结 04 解除冻结 05 解除轮候冻结 06 划拨 07 提取收入 08 冻结并划拨
            ,glzhhm -- 开户账号子账号
            ,zcmc -- 金融资产名称
            ,zclx -- 金融资产类型
            ,jldw -- 计量单位
            ,kznr -- 申请控制内容 1-账户下的资金 2-账户
            ,ksrq -- 申请控制开始日期
            ,jsrq -- 申请控制结束日期
            ,je -- 申请控制金额
            ,sfjh -- 是否结汇
            ,ckwh -- 裁定文书号
            ,zxkzhhm -- 执行款专户户名
            ,zxkzhkhh -- 执行款专户开户行
            ,zxkzhkhhhh -- 执行款专户开户行行号
            ,zxkzhzh -- 执行款专户账号
            ,zxkzhlx -- 执行款专户类型
            ,ydjah -- 原冻结案号
            ,ydjdh -- 原冻结请求单单号
            ,result -- 处理状态 0-录入 1-已处理 2-处理失败 3-已登记
            ,cpxszl -- 产品销售种类
            ,dqh -- 地区号
            ,jrcpbh -- 金融产品编号
            ,lczh -- 理财账号
            ,zjhkzh -- 资金回款账户
            ,se -- 申请控制数量/份额/金额
            ,jrkzflag -- 金融产品冻结标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.transdt -- 交易日期
    ,o.transtm -- 交易时间
    ,o.uptdttm -- 更新时间
    ,o.diskno -- 批次号
    ,o.bdhm -- 控制请求单号
    ,o.ccxh -- 序号
    ,o.khzh -- 开户账号
    ,o.cclb -- 账户类别
    ,o.khwd -- 开户网点
    ,o.khwddm -- 开户网点代码
    ,o.bz -- 申请控制金额币种
    ,o.kzlx -- 控制类型 1-存款 2-非存款类金融资产
    ,o.kzcs -- 控制措施 01 冻结02 继续冻结 03 轮候冻结 04 解除冻结 05 解除轮候冻结 06 划拨 07 提取收入 08 冻结并划拨
    ,o.glzhhm -- 开户账号子账号
    ,o.zcmc -- 金融资产名称
    ,o.zclx -- 金融资产类型
    ,o.jldw -- 计量单位
    ,o.kznr -- 申请控制内容 1-账户下的资金 2-账户
    ,o.ksrq -- 申请控制开始日期
    ,o.jsrq -- 申请控制结束日期
    ,o.je -- 申请控制金额
    ,o.sfjh -- 是否结汇
    ,o.ckwh -- 裁定文书号
    ,o.zxkzhhm -- 执行款专户户名
    ,o.zxkzhkhh -- 执行款专户开户行
    ,o.zxkzhkhhhh -- 执行款专户开户行行号
    ,o.zxkzhzh -- 执行款专户账号
    ,o.zxkzhlx -- 执行款专户类型
    ,o.ydjah -- 原冻结案号
    ,o.ydjdh -- 原冻结请求单单号
    ,o.result -- 处理状态 0-录入 1-已处理 2-处理失败 3-已登记
    ,o.cpxszl -- 产品销售种类
    ,o.dqh -- 地区号
    ,o.jrcpbh -- 金融产品编号
    ,o.lczh -- 理财账号
    ,o.zjhkzh -- 资金回款账户
    ,o.se -- 申请控制数量/份额/金额
    ,o.jrkzflag -- 金融产品冻结标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo_bk o
    left join ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo_op n
        on
            o.bdhm = n.bdhm
            and o.ccxh = n.ccxh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo_cl d
        on
            o.bdhm = d.bdhm
            and o.ccxh = d.ccxh
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo exchange partition p_19000101 with table ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo_cl;
alter table ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo exchange partition p_20991231 with table ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo_op purge;
drop table ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0ptgetxzkzzhxxinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0ptgetxzkzzhxxinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
