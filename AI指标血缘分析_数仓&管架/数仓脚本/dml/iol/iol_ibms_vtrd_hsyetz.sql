/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_vtrd_hsyetz
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
create table ${iol_schema}.ibms_vtrd_hsyetz_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_vtrd_hsyetz
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_vtrd_hsyetz_op purge;
drop table ${iol_schema}.ibms_vtrd_hsyetz_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_vtrd_hsyetz_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_vtrd_hsyetz where 0=1;

create table ${iol_schema}.ibms_vtrd_hsyetz_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_vtrd_hsyetz where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_vtrd_hsyetz_cl(
            obj_id -- 核算ID
            ,beg_date -- 余额日期
            ,org_id -- 机构号
            ,secu_acct_name -- 投组单元
            ,secu_acctg_type_name -- 会计分类
            ,p_type_name -- 产品类型
            ,p_class -- 产品分类
            ,trade_id -- 交易单号
            ,i_code -- 金融工具代码
            ,i_code1 -- 金融工具代码(场所)
            ,i_name -- 金融工具名称
            ,trd_orddate -- 交易日期
            ,trd_party_name -- 交易对手
            ,trd_party_class -- 交易对手客户分类
            ,issue_name -- 发行人/实际融资人
            ,issue_class -- 实际融资人客户分类
            ,currency -- 币种
            ,cp -- 投资本金
            ,coupon -- 执行利率
            ,inst_start_date -- 起息日
            ,inst_mrt_date -- 到期日
            ,first_payment_date -- 首次付息日
            ,pay_freq_name -- 付息频率
            ,daycount_name -- 计息基准
            ,coupon_type_name -- 息票类型
            ,s_grade -- 债项/主体评级
            ,tzye -- 投资余额
            ,zmye -- 账面余额
            ,tycb -- 摊余成本(元)
            ,ai -- 应计利息(元)
            ,due_cp -- 应收/付未收/付本金
            ,due_ai -- 应收/付未收/付利息
            ,amrt_ir -- 利息调整(元)
            ,chg_fv -- 当前公允价值变动损益
            ,year_prft_ir -- 本年利息收入
            ,prft_ir -- 累积利息收入(元)
            ,year_prft_trd -- 本年买卖损益(元)
            ,prft_trd -- 累积买卖损益(元)
            ,tax_due_amrt -- 摊销利息收入增值税
            ,tax_ai -- 计提利息收入增值税
            ,tax_due_trd -- 买卖损益增值税
            ,ai_cost -- 已预付利息(元)
            ,due_amrt_ir -- 待摊销利息(元)
            ,prft_ir_amrt -- 已摊销利息(元)
            ,bw_ai -- 已转表外利息
            ,cp_subj_code -- 本金科目号
            ,prft_ir_subj_code -- 利息收入科目号
            ,ai_subj_code -- 应计利息科目号
            ,sfbb -- 是否保本
            ,ai_tax_rate -- 增值税税率(应计利息收入)
            ,amrt_tax_rate -- 增值税税率(摊销利息收入)
            ,trd_tax_rate -- 增值税税率(买卖损益)
            ,ftp_jzz -- FTP基准值
            ,ftp_rate -- 最终FTP利率
            ,yrj -- 月日均
            ,jrj -- 季日均
            ,nrj -- 年日均
            ,hxkhh -- 交易对手核心客户号
            ,hxkhh1 -- 实际融资人核心客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_vtrd_hsyetz_op(
            obj_id -- 核算ID
            ,beg_date -- 余额日期
            ,org_id -- 机构号
            ,secu_acct_name -- 投组单元
            ,secu_acctg_type_name -- 会计分类
            ,p_type_name -- 产品类型
            ,p_class -- 产品分类
            ,trade_id -- 交易单号
            ,i_code -- 金融工具代码
            ,i_code1 -- 金融工具代码(场所)
            ,i_name -- 金融工具名称
            ,trd_orddate -- 交易日期
            ,trd_party_name -- 交易对手
            ,trd_party_class -- 交易对手客户分类
            ,issue_name -- 发行人/实际融资人
            ,issue_class -- 实际融资人客户分类
            ,currency -- 币种
            ,cp -- 投资本金
            ,coupon -- 执行利率
            ,inst_start_date -- 起息日
            ,inst_mrt_date -- 到期日
            ,first_payment_date -- 首次付息日
            ,pay_freq_name -- 付息频率
            ,daycount_name -- 计息基准
            ,coupon_type_name -- 息票类型
            ,s_grade -- 债项/主体评级
            ,tzye -- 投资余额
            ,zmye -- 账面余额
            ,tycb -- 摊余成本(元)
            ,ai -- 应计利息(元)
            ,due_cp -- 应收/付未收/付本金
            ,due_ai -- 应收/付未收/付利息
            ,amrt_ir -- 利息调整(元)
            ,chg_fv -- 当前公允价值变动损益
            ,year_prft_ir -- 本年利息收入
            ,prft_ir -- 累积利息收入(元)
            ,year_prft_trd -- 本年买卖损益(元)
            ,prft_trd -- 累积买卖损益(元)
            ,tax_due_amrt -- 摊销利息收入增值税
            ,tax_ai -- 计提利息收入增值税
            ,tax_due_trd -- 买卖损益增值税
            ,ai_cost -- 已预付利息(元)
            ,due_amrt_ir -- 待摊销利息(元)
            ,prft_ir_amrt -- 已摊销利息(元)
            ,bw_ai -- 已转表外利息
            ,cp_subj_code -- 本金科目号
            ,prft_ir_subj_code -- 利息收入科目号
            ,ai_subj_code -- 应计利息科目号
            ,sfbb -- 是否保本
            ,ai_tax_rate -- 增值税税率(应计利息收入)
            ,amrt_tax_rate -- 增值税税率(摊销利息收入)
            ,trd_tax_rate -- 增值税税率(买卖损益)
            ,ftp_jzz -- FTP基准值
            ,ftp_rate -- 最终FTP利率
            ,yrj -- 月日均
            ,jrj -- 季日均
            ,nrj -- 年日均
            ,hxkhh -- 交易对手核心客户号
            ,hxkhh1 -- 实际融资人核心客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.obj_id, o.obj_id) as obj_id -- 核算ID
    ,nvl(n.beg_date, o.beg_date) as beg_date -- 余额日期
    ,nvl(n.org_id, o.org_id) as org_id -- 机构号
    ,nvl(n.secu_acct_name, o.secu_acct_name) as secu_acct_name -- 投组单元
    ,nvl(n.secu_acctg_type_name, o.secu_acctg_type_name) as secu_acctg_type_name -- 会计分类
    ,nvl(n.p_type_name, o.p_type_name) as p_type_name -- 产品类型
    ,nvl(n.p_class, o.p_class) as p_class -- 产品分类
    ,nvl(n.trade_id, o.trade_id) as trade_id -- 交易单号
    ,nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.i_code1, o.i_code1) as i_code1 -- 金融工具代码(场所)
    ,nvl(n.i_name, o.i_name) as i_name -- 金融工具名称
    ,nvl(n.trd_orddate, o.trd_orddate) as trd_orddate -- 交易日期
    ,nvl(n.trd_party_name, o.trd_party_name) as trd_party_name -- 交易对手
    ,nvl(n.trd_party_class, o.trd_party_class) as trd_party_class -- 交易对手客户分类
    ,nvl(n.issue_name, o.issue_name) as issue_name -- 发行人/实际融资人
    ,nvl(n.issue_class, o.issue_class) as issue_class -- 实际融资人客户分类
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.cp, o.cp) as cp -- 投资本金
    ,nvl(n.coupon, o.coupon) as coupon -- 执行利率
    ,nvl(n.inst_start_date, o.inst_start_date) as inst_start_date -- 起息日
    ,nvl(n.inst_mrt_date, o.inst_mrt_date) as inst_mrt_date -- 到期日
    ,nvl(n.first_payment_date, o.first_payment_date) as first_payment_date -- 首次付息日
    ,nvl(n.pay_freq_name, o.pay_freq_name) as pay_freq_name -- 付息频率
    ,nvl(n.daycount_name, o.daycount_name) as daycount_name -- 计息基准
    ,nvl(n.coupon_type_name, o.coupon_type_name) as coupon_type_name -- 息票类型
    ,nvl(n.s_grade, o.s_grade) as s_grade -- 债项/主体评级
    ,nvl(n.tzye, o.tzye) as tzye -- 投资余额
    ,nvl(n.zmye, o.zmye) as zmye -- 账面余额
    ,nvl(n.tycb, o.tycb) as tycb -- 摊余成本(元)
    ,nvl(n.ai, o.ai) as ai -- 应计利息(元)
    ,nvl(n.due_cp, o.due_cp) as due_cp -- 应收/付未收/付本金
    ,nvl(n.due_ai, o.due_ai) as due_ai -- 应收/付未收/付利息
    ,nvl(n.amrt_ir, o.amrt_ir) as amrt_ir -- 利息调整(元)
    ,nvl(n.chg_fv, o.chg_fv) as chg_fv -- 当前公允价值变动损益
    ,nvl(n.year_prft_ir, o.year_prft_ir) as year_prft_ir -- 本年利息收入
    ,nvl(n.prft_ir, o.prft_ir) as prft_ir -- 累积利息收入(元)
    ,nvl(n.year_prft_trd, o.year_prft_trd) as year_prft_trd -- 本年买卖损益(元)
    ,nvl(n.prft_trd, o.prft_trd) as prft_trd -- 累积买卖损益(元)
    ,nvl(n.tax_due_amrt, o.tax_due_amrt) as tax_due_amrt -- 摊销利息收入增值税
    ,nvl(n.tax_ai, o.tax_ai) as tax_ai -- 计提利息收入增值税
    ,nvl(n.tax_due_trd, o.tax_due_trd) as tax_due_trd -- 买卖损益增值税
    ,nvl(n.ai_cost, o.ai_cost) as ai_cost -- 已预付利息(元)
    ,nvl(n.due_amrt_ir, o.due_amrt_ir) as due_amrt_ir -- 待摊销利息(元)
    ,nvl(n.prft_ir_amrt, o.prft_ir_amrt) as prft_ir_amrt -- 已摊销利息(元)
    ,nvl(n.bw_ai, o.bw_ai) as bw_ai -- 已转表外利息
    ,nvl(n.cp_subj_code, o.cp_subj_code) as cp_subj_code -- 本金科目号
    ,nvl(n.prft_ir_subj_code, o.prft_ir_subj_code) as prft_ir_subj_code -- 利息收入科目号
    ,nvl(n.ai_subj_code, o.ai_subj_code) as ai_subj_code -- 应计利息科目号
    ,nvl(n.sfbb, o.sfbb) as sfbb -- 是否保本
    ,nvl(n.ai_tax_rate, o.ai_tax_rate) as ai_tax_rate -- 增值税税率(应计利息收入)
    ,nvl(n.amrt_tax_rate, o.amrt_tax_rate) as amrt_tax_rate -- 增值税税率(摊销利息收入)
    ,nvl(n.trd_tax_rate, o.trd_tax_rate) as trd_tax_rate -- 增值税税率(买卖损益)
    ,nvl(n.ftp_jzz, o.ftp_jzz) as ftp_jzz -- FTP基准值
    ,nvl(n.ftp_rate, o.ftp_rate) as ftp_rate -- 最终FTP利率
    ,nvl(n.yrj, o.yrj) as yrj -- 月日均
    ,nvl(n.jrj, o.jrj) as jrj -- 季日均
    ,nvl(n.nrj, o.nrj) as nrj -- 年日均
    ,nvl(n.hxkhh, o.hxkhh) as hxkhh -- 交易对手核心客户号
    ,nvl(n.hxkhh1, o.hxkhh1) as hxkhh1 -- 实际融资人核心客户号
    ,case when
            n.obj_id is null
            and n.beg_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.obj_id is null
            and n.beg_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.obj_id is null
            and n.beg_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_vtrd_hsyetz_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_vtrd_hsyetz where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.obj_id = n.obj_id
            and o.beg_date = n.beg_date
where (
        o.obj_id is null
        and o.beg_date is null
    )
    or (
        n.obj_id is null
        and n.beg_date is null
    )
    or (
        o.org_id <> n.org_id
        or o.secu_acct_name <> n.secu_acct_name
        or o.secu_acctg_type_name <> n.secu_acctg_type_name
        or o.p_type_name <> n.p_type_name
        or o.p_class <> n.p_class
        or o.trade_id <> n.trade_id
        or o.i_code <> n.i_code
        or o.i_code1 <> n.i_code1
        or o.i_name <> n.i_name
        or o.trd_orddate <> n.trd_orddate
        or o.trd_party_name <> n.trd_party_name
        or o.trd_party_class <> n.trd_party_class
        or o.issue_name <> n.issue_name
        or o.issue_class <> n.issue_class
        or o.currency <> n.currency
        or o.cp <> n.cp
        or o.coupon <> n.coupon
        or o.inst_start_date <> n.inst_start_date
        or o.inst_mrt_date <> n.inst_mrt_date
        or o.first_payment_date <> n.first_payment_date
        or o.pay_freq_name <> n.pay_freq_name
        or o.daycount_name <> n.daycount_name
        or o.coupon_type_name <> n.coupon_type_name
        or o.s_grade <> n.s_grade
        or o.tzye <> n.tzye
        or o.zmye <> n.zmye
        or o.tycb <> n.tycb
        or o.ai <> n.ai
        or o.due_cp <> n.due_cp
        or o.due_ai <> n.due_ai
        or o.amrt_ir <> n.amrt_ir
        or o.chg_fv <> n.chg_fv
        or o.year_prft_ir <> n.year_prft_ir
        or o.prft_ir <> n.prft_ir
        or o.year_prft_trd <> n.year_prft_trd
        or o.prft_trd <> n.prft_trd
        or o.tax_due_amrt <> n.tax_due_amrt
        or o.tax_ai <> n.tax_ai
        or o.tax_due_trd <> n.tax_due_trd
        or o.ai_cost <> n.ai_cost
        or o.due_amrt_ir <> n.due_amrt_ir
        or o.prft_ir_amrt <> n.prft_ir_amrt
        or o.bw_ai <> n.bw_ai
        or o.cp_subj_code <> n.cp_subj_code
        or o.prft_ir_subj_code <> n.prft_ir_subj_code
        or o.ai_subj_code <> n.ai_subj_code
        or o.sfbb <> n.sfbb
        or o.ai_tax_rate <> n.ai_tax_rate
        or o.amrt_tax_rate <> n.amrt_tax_rate
        or o.trd_tax_rate <> n.trd_tax_rate
        or o.ftp_jzz <> n.ftp_jzz
        or o.ftp_rate <> n.ftp_rate
        or o.yrj <> n.yrj
        or o.jrj <> n.jrj
        or o.nrj <> n.nrj
        or o.hxkhh <> n.hxkhh
        or o.hxkhh1 <> n.hxkhh1
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_vtrd_hsyetz_cl(
            obj_id -- 核算ID
            ,beg_date -- 余额日期
            ,org_id -- 机构号
            ,secu_acct_name -- 投组单元
            ,secu_acctg_type_name -- 会计分类
            ,p_type_name -- 产品类型
            ,p_class -- 产品分类
            ,trade_id -- 交易单号
            ,i_code -- 金融工具代码
            ,i_code1 -- 金融工具代码(场所)
            ,i_name -- 金融工具名称
            ,trd_orddate -- 交易日期
            ,trd_party_name -- 交易对手
            ,trd_party_class -- 交易对手客户分类
            ,issue_name -- 发行人/实际融资人
            ,issue_class -- 实际融资人客户分类
            ,currency -- 币种
            ,cp -- 投资本金
            ,coupon -- 执行利率
            ,inst_start_date -- 起息日
            ,inst_mrt_date -- 到期日
            ,first_payment_date -- 首次付息日
            ,pay_freq_name -- 付息频率
            ,daycount_name -- 计息基准
            ,coupon_type_name -- 息票类型
            ,s_grade -- 债项/主体评级
            ,tzye -- 投资余额
            ,zmye -- 账面余额
            ,tycb -- 摊余成本(元)
            ,ai -- 应计利息(元)
            ,due_cp -- 应收/付未收/付本金
            ,due_ai -- 应收/付未收/付利息
            ,amrt_ir -- 利息调整(元)
            ,chg_fv -- 当前公允价值变动损益
            ,year_prft_ir -- 本年利息收入
            ,prft_ir -- 累积利息收入(元)
            ,year_prft_trd -- 本年买卖损益(元)
            ,prft_trd -- 累积买卖损益(元)
            ,tax_due_amrt -- 摊销利息收入增值税
            ,tax_ai -- 计提利息收入增值税
            ,tax_due_trd -- 买卖损益增值税
            ,ai_cost -- 已预付利息(元)
            ,due_amrt_ir -- 待摊销利息(元)
            ,prft_ir_amrt -- 已摊销利息(元)
            ,bw_ai -- 已转表外利息
            ,cp_subj_code -- 本金科目号
            ,prft_ir_subj_code -- 利息收入科目号
            ,ai_subj_code -- 应计利息科目号
            ,sfbb -- 是否保本
            ,ai_tax_rate -- 增值税税率(应计利息收入)
            ,amrt_tax_rate -- 增值税税率(摊销利息收入)
            ,trd_tax_rate -- 增值税税率(买卖损益)
            ,ftp_jzz -- FTP基准值
            ,ftp_rate -- 最终FTP利率
            ,yrj -- 月日均
            ,jrj -- 季日均
            ,nrj -- 年日均
            ,hxkhh -- 交易对手核心客户号
            ,hxkhh1 -- 实际融资人核心客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_vtrd_hsyetz_op(
            obj_id -- 核算ID
            ,beg_date -- 余额日期
            ,org_id -- 机构号
            ,secu_acct_name -- 投组单元
            ,secu_acctg_type_name -- 会计分类
            ,p_type_name -- 产品类型
            ,p_class -- 产品分类
            ,trade_id -- 交易单号
            ,i_code -- 金融工具代码
            ,i_code1 -- 金融工具代码(场所)
            ,i_name -- 金融工具名称
            ,trd_orddate -- 交易日期
            ,trd_party_name -- 交易对手
            ,trd_party_class -- 交易对手客户分类
            ,issue_name -- 发行人/实际融资人
            ,issue_class -- 实际融资人客户分类
            ,currency -- 币种
            ,cp -- 投资本金
            ,coupon -- 执行利率
            ,inst_start_date -- 起息日
            ,inst_mrt_date -- 到期日
            ,first_payment_date -- 首次付息日
            ,pay_freq_name -- 付息频率
            ,daycount_name -- 计息基准
            ,coupon_type_name -- 息票类型
            ,s_grade -- 债项/主体评级
            ,tzye -- 投资余额
            ,zmye -- 账面余额
            ,tycb -- 摊余成本(元)
            ,ai -- 应计利息(元)
            ,due_cp -- 应收/付未收/付本金
            ,due_ai -- 应收/付未收/付利息
            ,amrt_ir -- 利息调整(元)
            ,chg_fv -- 当前公允价值变动损益
            ,year_prft_ir -- 本年利息收入
            ,prft_ir -- 累积利息收入(元)
            ,year_prft_trd -- 本年买卖损益(元)
            ,prft_trd -- 累积买卖损益(元)
            ,tax_due_amrt -- 摊销利息收入增值税
            ,tax_ai -- 计提利息收入增值税
            ,tax_due_trd -- 买卖损益增值税
            ,ai_cost -- 已预付利息(元)
            ,due_amrt_ir -- 待摊销利息(元)
            ,prft_ir_amrt -- 已摊销利息(元)
            ,bw_ai -- 已转表外利息
            ,cp_subj_code -- 本金科目号
            ,prft_ir_subj_code -- 利息收入科目号
            ,ai_subj_code -- 应计利息科目号
            ,sfbb -- 是否保本
            ,ai_tax_rate -- 增值税税率(应计利息收入)
            ,amrt_tax_rate -- 增值税税率(摊销利息收入)
            ,trd_tax_rate -- 增值税税率(买卖损益)
            ,ftp_jzz -- FTP基准值
            ,ftp_rate -- 最终FTP利率
            ,yrj -- 月日均
            ,jrj -- 季日均
            ,nrj -- 年日均
            ,hxkhh -- 交易对手核心客户号
            ,hxkhh1 -- 实际融资人核心客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.obj_id -- 核算ID
    ,o.beg_date -- 余额日期
    ,o.org_id -- 机构号
    ,o.secu_acct_name -- 投组单元
    ,o.secu_acctg_type_name -- 会计分类
    ,o.p_type_name -- 产品类型
    ,o.p_class -- 产品分类
    ,o.trade_id -- 交易单号
    ,o.i_code -- 金融工具代码
    ,o.i_code1 -- 金融工具代码(场所)
    ,o.i_name -- 金融工具名称
    ,o.trd_orddate -- 交易日期
    ,o.trd_party_name -- 交易对手
    ,o.trd_party_class -- 交易对手客户分类
    ,o.issue_name -- 发行人/实际融资人
    ,o.issue_class -- 实际融资人客户分类
    ,o.currency -- 币种
    ,o.cp -- 投资本金
    ,o.coupon -- 执行利率
    ,o.inst_start_date -- 起息日
    ,o.inst_mrt_date -- 到期日
    ,o.first_payment_date -- 首次付息日
    ,o.pay_freq_name -- 付息频率
    ,o.daycount_name -- 计息基准
    ,o.coupon_type_name -- 息票类型
    ,o.s_grade -- 债项/主体评级
    ,o.tzye -- 投资余额
    ,o.zmye -- 账面余额
    ,o.tycb -- 摊余成本(元)
    ,o.ai -- 应计利息(元)
    ,o.due_cp -- 应收/付未收/付本金
    ,o.due_ai -- 应收/付未收/付利息
    ,o.amrt_ir -- 利息调整(元)
    ,o.chg_fv -- 当前公允价值变动损益
    ,o.year_prft_ir -- 本年利息收入
    ,o.prft_ir -- 累积利息收入(元)
    ,o.year_prft_trd -- 本年买卖损益(元)
    ,o.prft_trd -- 累积买卖损益(元)
    ,o.tax_due_amrt -- 摊销利息收入增值税
    ,o.tax_ai -- 计提利息收入增值税
    ,o.tax_due_trd -- 买卖损益增值税
    ,o.ai_cost -- 已预付利息(元)
    ,o.due_amrt_ir -- 待摊销利息(元)
    ,o.prft_ir_amrt -- 已摊销利息(元)
    ,o.bw_ai -- 已转表外利息
    ,o.cp_subj_code -- 本金科目号
    ,o.prft_ir_subj_code -- 利息收入科目号
    ,o.ai_subj_code -- 应计利息科目号
    ,o.sfbb -- 是否保本
    ,o.ai_tax_rate -- 增值税税率(应计利息收入)
    ,o.amrt_tax_rate -- 增值税税率(摊销利息收入)
    ,o.trd_tax_rate -- 增值税税率(买卖损益)
    ,o.ftp_jzz -- FTP基准值
    ,o.ftp_rate -- 最终FTP利率
    ,o.yrj -- 月日均
    ,o.jrj -- 季日均
    ,o.nrj -- 年日均
    ,o.hxkhh -- 交易对手核心客户号
    ,o.hxkhh1 -- 实际融资人核心客户号
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
from ${iol_schema}.ibms_vtrd_hsyetz_bk o
    left join ${iol_schema}.ibms_vtrd_hsyetz_op n
        on
            o.obj_id = n.obj_id
            and o.beg_date = n.beg_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_vtrd_hsyetz_cl d
        on
            o.obj_id = d.obj_id
            and o.beg_date = d.beg_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_vtrd_hsyetz;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_vtrd_hsyetz') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_vtrd_hsyetz drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_vtrd_hsyetz add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_vtrd_hsyetz exchange partition p_${batch_date} with table ${iol_schema}.ibms_vtrd_hsyetz_cl;
alter table ${iol_schema}.ibms_vtrd_hsyetz exchange partition p_20991231 with table ${iol_schema}.ibms_vtrd_hsyetz_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_vtrd_hsyetz to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_vtrd_hsyetz_op purge;
drop table ${iol_schema}.ibms_vtrd_hsyetz_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_vtrd_hsyetz_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_vtrd_hsyetz',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
