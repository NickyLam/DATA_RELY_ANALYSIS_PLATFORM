/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0jtpmisqryfxsatqquota
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
create table ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota_op purge;
drop table ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota where 0=1;

create table ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota_cl(
            mainseq -- 中台流水号
            ,transdt -- 交易日期
            ,status -- 交易状态 Z 初始状态 0-发送失败 1 发送成功
            ,trantype -- 交易类型 JH结汇 GH购汇
            ,idtype_code -- 证件类型
            ,idcode -- 证件号码
            ,ctycode -- 国家/地区代码
            ,ann_lcyamt_usd -- 本年额度内已结汇金额折美元
            ,ann_rem_lcyamt_usd -- 本年额度内剩余可结汇金额折美元
            ,cr_amt_usd_sumday -- 当日已存入金额折美元
            ,cr_amt_usd_sumyear -- 当年已存入金额折美元
            ,ann_fcyamt_usd -- 本年额度内已购汇金额折美元
            ,ann_rem_fcyamt_usd -- 本年额度内剩余可购汇金额折美元
            ,zq_amt_usd_date -- 当日已提取金额（折美元）
            ,zq_amt_usd_year -- 当年已提取金额（折美元）
            ,custname -- 交易主体姓名
            ,custtype_code -- 交易主体类型代码
            ,type_status -- 个人主体分类状态代码
            ,pub_date -- 发布日期
            ,end_date -- 到期日期
            ,pub_reason -- 发布原因
            ,pub_code -- 发布原因代码 01分拆收结汇境外汇款人02分拆收结汇参与者03分拆收结汇资金归集者04分拆购付汇资金提供者05-分拆购付汇参与者06分拆购付汇境外收款人07多次协助他人规避额度及真实性管理99其他
            ,pub_org -- 关注名单发布机构
            ,sign_status -- 风险提示函/告知书告知状态 0未告知1已告知
            ,is_check -- 是否是待核查处理个人  Y 是/ N 否
            ,is_notice -- 待核查处理个人是否已告知 Y 是/ N 否
            ,check_pub_date -- 待核查处理个人发布日期
            ,check_end_date -- 待核查处理个人到期日期
            ,check_pub_reason -- 待核查处理个人发布原因
            ,check_pub_code -- 待核查处理个人发布原因代码 01可疑现钞业务 02可疑结售汇业务 03可疑收支业务 04虚假申报信息 05其他业务
            ,check_pub_branch -- 待核查处理个人发布机构
            ,magebrn -- 机构号
            ,oprtlr -- 柜员号
            ,fronttrcd -- 中台交易码
            ,servicepath -- 访问服务信息
            ,remark -- 备注
            ,src -- 发起节点代码
            ,des -- 接收节点代码
            ,sendtime -- 发送时间
            ,common_org_code -- 机构代码
            ,msgno -- 报文参考号
            ,zyed_flag -- 占用额度标识 0是占用额度,1非占用额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota_op(
            mainseq -- 中台流水号
            ,transdt -- 交易日期
            ,status -- 交易状态 Z 初始状态 0-发送失败 1 发送成功
            ,trantype -- 交易类型 JH结汇 GH购汇
            ,idtype_code -- 证件类型
            ,idcode -- 证件号码
            ,ctycode -- 国家/地区代码
            ,ann_lcyamt_usd -- 本年额度内已结汇金额折美元
            ,ann_rem_lcyamt_usd -- 本年额度内剩余可结汇金额折美元
            ,cr_amt_usd_sumday -- 当日已存入金额折美元
            ,cr_amt_usd_sumyear -- 当年已存入金额折美元
            ,ann_fcyamt_usd -- 本年额度内已购汇金额折美元
            ,ann_rem_fcyamt_usd -- 本年额度内剩余可购汇金额折美元
            ,zq_amt_usd_date -- 当日已提取金额（折美元）
            ,zq_amt_usd_year -- 当年已提取金额（折美元）
            ,custname -- 交易主体姓名
            ,custtype_code -- 交易主体类型代码
            ,type_status -- 个人主体分类状态代码
            ,pub_date -- 发布日期
            ,end_date -- 到期日期
            ,pub_reason -- 发布原因
            ,pub_code -- 发布原因代码 01分拆收结汇境外汇款人02分拆收结汇参与者03分拆收结汇资金归集者04分拆购付汇资金提供者05-分拆购付汇参与者06分拆购付汇境外收款人07多次协助他人规避额度及真实性管理99其他
            ,pub_org -- 关注名单发布机构
            ,sign_status -- 风险提示函/告知书告知状态 0未告知1已告知
            ,is_check -- 是否是待核查处理个人  Y 是/ N 否
            ,is_notice -- 待核查处理个人是否已告知 Y 是/ N 否
            ,check_pub_date -- 待核查处理个人发布日期
            ,check_end_date -- 待核查处理个人到期日期
            ,check_pub_reason -- 待核查处理个人发布原因
            ,check_pub_code -- 待核查处理个人发布原因代码 01可疑现钞业务 02可疑结售汇业务 03可疑收支业务 04虚假申报信息 05其他业务
            ,check_pub_branch -- 待核查处理个人发布机构
            ,magebrn -- 机构号
            ,oprtlr -- 柜员号
            ,fronttrcd -- 中台交易码
            ,servicepath -- 访问服务信息
            ,remark -- 备注
            ,src -- 发起节点代码
            ,des -- 接收节点代码
            ,sendtime -- 发送时间
            ,common_org_code -- 机构代码
            ,msgno -- 报文参考号
            ,zyed_flag -- 占用额度标识 0是占用额度,1非占用额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.mainseq, o.mainseq) as mainseq -- 中台流水号
    ,nvl(n.transdt, o.transdt) as transdt -- 交易日期
    ,nvl(n.status, o.status) as status -- 交易状态 Z 初始状态 0-发送失败 1 发送成功
    ,nvl(n.trantype, o.trantype) as trantype -- 交易类型 JH结汇 GH购汇
    ,nvl(n.idtype_code, o.idtype_code) as idtype_code -- 证件类型
    ,nvl(n.idcode, o.idcode) as idcode -- 证件号码
    ,nvl(n.ctycode, o.ctycode) as ctycode -- 国家/地区代码
    ,nvl(n.ann_lcyamt_usd, o.ann_lcyamt_usd) as ann_lcyamt_usd -- 本年额度内已结汇金额折美元
    ,nvl(n.ann_rem_lcyamt_usd, o.ann_rem_lcyamt_usd) as ann_rem_lcyamt_usd -- 本年额度内剩余可结汇金额折美元
    ,nvl(n.cr_amt_usd_sumday, o.cr_amt_usd_sumday) as cr_amt_usd_sumday -- 当日已存入金额折美元
    ,nvl(n.cr_amt_usd_sumyear, o.cr_amt_usd_sumyear) as cr_amt_usd_sumyear -- 当年已存入金额折美元
    ,nvl(n.ann_fcyamt_usd, o.ann_fcyamt_usd) as ann_fcyamt_usd -- 本年额度内已购汇金额折美元
    ,nvl(n.ann_rem_fcyamt_usd, o.ann_rem_fcyamt_usd) as ann_rem_fcyamt_usd -- 本年额度内剩余可购汇金额折美元
    ,nvl(n.zq_amt_usd_date, o.zq_amt_usd_date) as zq_amt_usd_date -- 当日已提取金额（折美元）
    ,nvl(n.zq_amt_usd_year, o.zq_amt_usd_year) as zq_amt_usd_year -- 当年已提取金额（折美元）
    ,nvl(n.custname, o.custname) as custname -- 交易主体姓名
    ,nvl(n.custtype_code, o.custtype_code) as custtype_code -- 交易主体类型代码
    ,nvl(n.type_status, o.type_status) as type_status -- 个人主体分类状态代码
    ,nvl(n.pub_date, o.pub_date) as pub_date -- 发布日期
    ,nvl(n.end_date, o.end_date) as end_date -- 到期日期
    ,nvl(n.pub_reason, o.pub_reason) as pub_reason -- 发布原因
    ,nvl(n.pub_code, o.pub_code) as pub_code -- 发布原因代码 01分拆收结汇境外汇款人02分拆收结汇参与者03分拆收结汇资金归集者04分拆购付汇资金提供者05-分拆购付汇参与者06分拆购付汇境外收款人07多次协助他人规避额度及真实性管理99其他
    ,nvl(n.pub_org, o.pub_org) as pub_org -- 关注名单发布机构
    ,nvl(n.sign_status, o.sign_status) as sign_status -- 风险提示函/告知书告知状态 0未告知1已告知
    ,nvl(n.is_check, o.is_check) as is_check -- 是否是待核查处理个人  Y 是/ N 否
    ,nvl(n.is_notice, o.is_notice) as is_notice -- 待核查处理个人是否已告知 Y 是/ N 否
    ,nvl(n.check_pub_date, o.check_pub_date) as check_pub_date -- 待核查处理个人发布日期
    ,nvl(n.check_end_date, o.check_end_date) as check_end_date -- 待核查处理个人到期日期
    ,nvl(n.check_pub_reason, o.check_pub_reason) as check_pub_reason -- 待核查处理个人发布原因
    ,nvl(n.check_pub_code, o.check_pub_code) as check_pub_code -- 待核查处理个人发布原因代码 01可疑现钞业务 02可疑结售汇业务 03可疑收支业务 04虚假申报信息 05其他业务
    ,nvl(n.check_pub_branch, o.check_pub_branch) as check_pub_branch -- 待核查处理个人发布机构
    ,nvl(n.magebrn, o.magebrn) as magebrn -- 机构号
    ,nvl(n.oprtlr, o.oprtlr) as oprtlr -- 柜员号
    ,nvl(n.fronttrcd, o.fronttrcd) as fronttrcd -- 中台交易码
    ,nvl(n.servicepath, o.servicepath) as servicepath -- 访问服务信息
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.src, o.src) as src -- 发起节点代码
    ,nvl(n.des, o.des) as des -- 接收节点代码
    ,nvl(n.sendtime, o.sendtime) as sendtime -- 发送时间
    ,nvl(n.common_org_code, o.common_org_code) as common_org_code -- 机构代码
    ,nvl(n.msgno, o.msgno) as msgno -- 报文参考号
    ,nvl(n.zyed_flag, o.zyed_flag) as zyed_flag -- 占用额度标识 0是占用额度,1非占用额度
    ,case when
            n.mainseq is null
            and n.transdt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.mainseq is null
            and n.transdt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.mainseq is null
            and n.transdt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a0jtpmisqryfxsatqquota where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.mainseq = n.mainseq
            and o.transdt = n.transdt
where (
        o.mainseq is null
        and o.transdt is null
    )
    or (
        n.mainseq is null
        and n.transdt is null
    )
    or (
        o.status <> n.status
        or o.trantype <> n.trantype
        or o.idtype_code <> n.idtype_code
        or o.idcode <> n.idcode
        or o.ctycode <> n.ctycode
        or o.ann_lcyamt_usd <> n.ann_lcyamt_usd
        or o.ann_rem_lcyamt_usd <> n.ann_rem_lcyamt_usd
        or o.cr_amt_usd_sumday <> n.cr_amt_usd_sumday
        or o.cr_amt_usd_sumyear <> n.cr_amt_usd_sumyear
        or o.ann_fcyamt_usd <> n.ann_fcyamt_usd
        or o.ann_rem_fcyamt_usd <> n.ann_rem_fcyamt_usd
        or o.zq_amt_usd_date <> n.zq_amt_usd_date
        or o.zq_amt_usd_year <> n.zq_amt_usd_year
        or o.custname <> n.custname
        or o.custtype_code <> n.custtype_code
        or o.type_status <> n.type_status
        or o.pub_date <> n.pub_date
        or o.end_date <> n.end_date
        or o.pub_reason <> n.pub_reason
        or o.pub_code <> n.pub_code
        or o.pub_org <> n.pub_org
        or o.sign_status <> n.sign_status
        or o.is_check <> n.is_check
        or o.is_notice <> n.is_notice
        or o.check_pub_date <> n.check_pub_date
        or o.check_end_date <> n.check_end_date
        or o.check_pub_reason <> n.check_pub_reason
        or o.check_pub_code <> n.check_pub_code
        or o.check_pub_branch <> n.check_pub_branch
        or o.magebrn <> n.magebrn
        or o.oprtlr <> n.oprtlr
        or o.fronttrcd <> n.fronttrcd
        or o.servicepath <> n.servicepath
        or o.remark <> n.remark
        or o.src <> n.src
        or o.des <> n.des
        or o.sendtime <> n.sendtime
        or o.common_org_code <> n.common_org_code
        or o.msgno <> n.msgno
        or o.zyed_flag <> n.zyed_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota_cl(
            mainseq -- 中台流水号
            ,transdt -- 交易日期
            ,status -- 交易状态 Z 初始状态 0-发送失败 1 发送成功
            ,trantype -- 交易类型 JH结汇 GH购汇
            ,idtype_code -- 证件类型
            ,idcode -- 证件号码
            ,ctycode -- 国家/地区代码
            ,ann_lcyamt_usd -- 本年额度内已结汇金额折美元
            ,ann_rem_lcyamt_usd -- 本年额度内剩余可结汇金额折美元
            ,cr_amt_usd_sumday -- 当日已存入金额折美元
            ,cr_amt_usd_sumyear -- 当年已存入金额折美元
            ,ann_fcyamt_usd -- 本年额度内已购汇金额折美元
            ,ann_rem_fcyamt_usd -- 本年额度内剩余可购汇金额折美元
            ,zq_amt_usd_date -- 当日已提取金额（折美元）
            ,zq_amt_usd_year -- 当年已提取金额（折美元）
            ,custname -- 交易主体姓名
            ,custtype_code -- 交易主体类型代码
            ,type_status -- 个人主体分类状态代码
            ,pub_date -- 发布日期
            ,end_date -- 到期日期
            ,pub_reason -- 发布原因
            ,pub_code -- 发布原因代码 01分拆收结汇境外汇款人02分拆收结汇参与者03分拆收结汇资金归集者04分拆购付汇资金提供者05-分拆购付汇参与者06分拆购付汇境外收款人07多次协助他人规避额度及真实性管理99其他
            ,pub_org -- 关注名单发布机构
            ,sign_status -- 风险提示函/告知书告知状态 0未告知1已告知
            ,is_check -- 是否是待核查处理个人  Y 是/ N 否
            ,is_notice -- 待核查处理个人是否已告知 Y 是/ N 否
            ,check_pub_date -- 待核查处理个人发布日期
            ,check_end_date -- 待核查处理个人到期日期
            ,check_pub_reason -- 待核查处理个人发布原因
            ,check_pub_code -- 待核查处理个人发布原因代码 01可疑现钞业务 02可疑结售汇业务 03可疑收支业务 04虚假申报信息 05其他业务
            ,check_pub_branch -- 待核查处理个人发布机构
            ,magebrn -- 机构号
            ,oprtlr -- 柜员号
            ,fronttrcd -- 中台交易码
            ,servicepath -- 访问服务信息
            ,remark -- 备注
            ,src -- 发起节点代码
            ,des -- 接收节点代码
            ,sendtime -- 发送时间
            ,common_org_code -- 机构代码
            ,msgno -- 报文参考号
            ,zyed_flag -- 占用额度标识 0是占用额度,1非占用额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota_op(
            mainseq -- 中台流水号
            ,transdt -- 交易日期
            ,status -- 交易状态 Z 初始状态 0-发送失败 1 发送成功
            ,trantype -- 交易类型 JH结汇 GH购汇
            ,idtype_code -- 证件类型
            ,idcode -- 证件号码
            ,ctycode -- 国家/地区代码
            ,ann_lcyamt_usd -- 本年额度内已结汇金额折美元
            ,ann_rem_lcyamt_usd -- 本年额度内剩余可结汇金额折美元
            ,cr_amt_usd_sumday -- 当日已存入金额折美元
            ,cr_amt_usd_sumyear -- 当年已存入金额折美元
            ,ann_fcyamt_usd -- 本年额度内已购汇金额折美元
            ,ann_rem_fcyamt_usd -- 本年额度内剩余可购汇金额折美元
            ,zq_amt_usd_date -- 当日已提取金额（折美元）
            ,zq_amt_usd_year -- 当年已提取金额（折美元）
            ,custname -- 交易主体姓名
            ,custtype_code -- 交易主体类型代码
            ,type_status -- 个人主体分类状态代码
            ,pub_date -- 发布日期
            ,end_date -- 到期日期
            ,pub_reason -- 发布原因
            ,pub_code -- 发布原因代码 01分拆收结汇境外汇款人02分拆收结汇参与者03分拆收结汇资金归集者04分拆购付汇资金提供者05-分拆购付汇参与者06分拆购付汇境外收款人07多次协助他人规避额度及真实性管理99其他
            ,pub_org -- 关注名单发布机构
            ,sign_status -- 风险提示函/告知书告知状态 0未告知1已告知
            ,is_check -- 是否是待核查处理个人  Y 是/ N 否
            ,is_notice -- 待核查处理个人是否已告知 Y 是/ N 否
            ,check_pub_date -- 待核查处理个人发布日期
            ,check_end_date -- 待核查处理个人到期日期
            ,check_pub_reason -- 待核查处理个人发布原因
            ,check_pub_code -- 待核查处理个人发布原因代码 01可疑现钞业务 02可疑结售汇业务 03可疑收支业务 04虚假申报信息 05其他业务
            ,check_pub_branch -- 待核查处理个人发布机构
            ,magebrn -- 机构号
            ,oprtlr -- 柜员号
            ,fronttrcd -- 中台交易码
            ,servicepath -- 访问服务信息
            ,remark -- 备注
            ,src -- 发起节点代码
            ,des -- 接收节点代码
            ,sendtime -- 发送时间
            ,common_org_code -- 机构代码
            ,msgno -- 报文参考号
            ,zyed_flag -- 占用额度标识 0是占用额度,1非占用额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.mainseq -- 中台流水号
    ,o.transdt -- 交易日期
    ,o.status -- 交易状态 Z 初始状态 0-发送失败 1 发送成功
    ,o.trantype -- 交易类型 JH结汇 GH购汇
    ,o.idtype_code -- 证件类型
    ,o.idcode -- 证件号码
    ,o.ctycode -- 国家/地区代码
    ,o.ann_lcyamt_usd -- 本年额度内已结汇金额折美元
    ,o.ann_rem_lcyamt_usd -- 本年额度内剩余可结汇金额折美元
    ,o.cr_amt_usd_sumday -- 当日已存入金额折美元
    ,o.cr_amt_usd_sumyear -- 当年已存入金额折美元
    ,o.ann_fcyamt_usd -- 本年额度内已购汇金额折美元
    ,o.ann_rem_fcyamt_usd -- 本年额度内剩余可购汇金额折美元
    ,o.zq_amt_usd_date -- 当日已提取金额（折美元）
    ,o.zq_amt_usd_year -- 当年已提取金额（折美元）
    ,o.custname -- 交易主体姓名
    ,o.custtype_code -- 交易主体类型代码
    ,o.type_status -- 个人主体分类状态代码
    ,o.pub_date -- 发布日期
    ,o.end_date -- 到期日期
    ,o.pub_reason -- 发布原因
    ,o.pub_code -- 发布原因代码 01分拆收结汇境外汇款人02分拆收结汇参与者03分拆收结汇资金归集者04分拆购付汇资金提供者05-分拆购付汇参与者06分拆购付汇境外收款人07多次协助他人规避额度及真实性管理99其他
    ,o.pub_org -- 关注名单发布机构
    ,o.sign_status -- 风险提示函/告知书告知状态 0未告知1已告知
    ,o.is_check -- 是否是待核查处理个人  Y 是/ N 否
    ,o.is_notice -- 待核查处理个人是否已告知 Y 是/ N 否
    ,o.check_pub_date -- 待核查处理个人发布日期
    ,o.check_end_date -- 待核查处理个人到期日期
    ,o.check_pub_reason -- 待核查处理个人发布原因
    ,o.check_pub_code -- 待核查处理个人发布原因代码 01可疑现钞业务 02可疑结售汇业务 03可疑收支业务 04虚假申报信息 05其他业务
    ,o.check_pub_branch -- 待核查处理个人发布机构
    ,o.magebrn -- 机构号
    ,o.oprtlr -- 柜员号
    ,o.fronttrcd -- 中台交易码
    ,o.servicepath -- 访问服务信息
    ,o.remark -- 备注
    ,o.src -- 发起节点代码
    ,o.des -- 接收节点代码
    ,o.sendtime -- 发送时间
    ,o.common_org_code -- 机构代码
    ,o.msgno -- 报文参考号
    ,o.zyed_flag -- 占用额度标识 0是占用额度,1非占用额度
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
from ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota_bk o
    left join ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota_op n
        on
            o.mainseq = n.mainseq
            and o.transdt = n.transdt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota_cl d
        on
            o.mainseq = d.mainseq
            and o.transdt = d.transdt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a0jtpmisqryfxsatqquota') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota_cl;
alter table ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota exchange partition p_20991231 with table ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota_op purge;
drop table ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0jtpmisqryfxsatqquota',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
