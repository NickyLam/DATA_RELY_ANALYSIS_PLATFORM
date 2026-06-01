/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_tyffzckmx
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxbb_tyffzckmx_ex purge;
alter table ${iol_schema}.pams_jxbb_tyffzckmx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.pams_jxbb_tyffzckmx truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_jxbb_tyffzckmx_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_tyffzckmx where 0=1;

insert /*+ append */ into ${iol_schema}.pams_jxbb_tyffzckmx_ex(
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,ywbh -- 业务编号
    ,jrgjdm -- 金融工具代码
    ,jrgjmc -- 金融工具名称
    ,jyssjgdh -- 交易所属机构
    ,jgmc -- 机构名称
    ,kjfl -- 会计分类
    ,cplx -- 产品类型
    ,jyrq -- 交易日期
    ,jydskhh -- 交易对手客户号
    ,jyds -- 交易对手
    ,jydslx -- 交易对手客户分类
    ,sjrzrkhh -- 发行人/实际融资人客户号
    ,sjrzr -- 发行人/实际融资人
    ,sjrzrlx -- 实际融资人客户分类
    ,bz -- 币种
    ,tzbj -- 投资本金(元)
    ,zxll -- 执行利率
    ,qxr -- 起息日
    ,dqr -- 到期日期
    ,scfxrq -- 首次付息日期
    ,fxpl -- 付息频率
    ,jxjz -- 计息基准
    ,tzye -- 投资余额
    ,zmye -- 账面余额
    ,dqgyjgbdsy -- 当前公允价值变动损益
    ,drlxsr -- 当日利息收入
    ,dylxsr -- 当月利息收入
    ,bnlxsr -- 本年利息收入(元)
    ,ljlxsr -- 累计利息收入
    ,drlxzc -- 当日利息支出(元)
    ,dylxzc -- 当月利息支出
    ,djlxzc -- 当季利息支出
    ,dnlxzc -- 本年利息支出(元)
    ,lxsrzzs -- 利息收入增值税(元),
    ,bnmmsy -- 半年买卖损益
    ,ljmmsy -- 累计买卖损益
    ,yzbwlx -- 已转表外利息(元)
    ,bjkmh -- 本金科目号
    ,bjkmmc -- 本金科目名称
    ,ftpll -- 准备金ftp利率
    ,zhnrjye -- 账户年日均余额
    ,zhjrjye -- 账户季日均余额
    ,zhyrjye -- 账户月日均余额
    ,fphyrj -- 分配后月日均
    ,fphjrj -- 分配后季日均
    ,fphnrj -- 分配后年日均
    ,zjsr -- 中间收入
    ,ftpsyrlj -- ftp收益日累计
    ,ftpsyylj -- ftp收益月累计
    ,ftpsynlj -- ftp收益年累计
    ,ftpsyljlj -- ftp收益累计累计
    ,fpjs -- 分配角色
    ,khdxdh -- 考核对象代号
    ,zlbl -- 增量比例
    ,xplx -- 息票类型
    ,jydslxms -- 交易对手类型描述
    ,sjrzrlxms -- 事件rzrlxms
    ,jxjzms -- 结息基准描述
    ,cplxmc -- 产品类型名称
    ,tzid -- 投组id
    ,sjly -- 数据来源
    ,hydh -- 行员代号
    ,hymc -- 行员名称
    ,ssjgdh -- 机构代号
    ,fptx -- 所属条线
    ,txfpbl -- 条线分配比例
    ,ssjgmc -- 机构名称
    ,hsfxjqzcje -- 缓释后的风险加权资产金额
    ,tzsy -- 调整收益
    ,tzsyylj -- 调整收益月累计
    ,tzsyjlj -- 调整收益季累计
    ,tzsynlj -- 调整收益年累计
    ,blqtzsy -- 补录前调整收益
    ,blqtzsyylj -- 补录前调整收益月累计
    ,blqtzsyjlj -- 补录前调整收益季累计
    ,blqtzsynlj -- 补录前调整收益年累计
    ,blsyje -- 补录收益金额
    ,blsyjeylj -- 补录收益金额月累计
    ,blsyjejlj -- 补录收益金额季累计
    ,blsyjenlj -- 补录收益金额年累计
    ,jgkhdxdh -- 机构考核对象代号
    ,ljtzysje -- 累计调整营收金额
    ,tzhljftpjsy -- 调整后累计ftp净收益
    ,ljtzfyje -- 累计调整费用金额
    ,jjljftpjsy -- 计奖累计ftp净收益
    ,dytzysje -- 月累计调整营收金额
    ,tzhdyftpjsy -- 调整后月累计ftp净收益
    ,dytzfyje -- 月累计调整费用金额
    ,jjdyftpjsy -- 计奖月累计ftp净收益
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,ywbh -- 业务编号
    ,jrgjdm -- 金融工具代码
    ,jrgjmc -- 金融工具名称
    ,jyssjgdh -- 交易所属机构
    ,jgmc -- 机构名称
    ,kjfl -- 会计分类
    ,cplx -- 产品类型
    ,jyrq -- 交易日期
    ,jydskhh -- 交易对手客户号
    ,jyds -- 交易对手
    ,jydslx -- 交易对手客户分类
    ,sjrzrkhh -- 发行人/实际融资人客户号
    ,sjrzr -- 发行人/实际融资人
    ,sjrzrlx -- 实际融资人客户分类
    ,bz -- 币种
    ,tzbj -- 投资本金(元)
    ,zxll -- 执行利率
    ,qxr -- 起息日
    ,dqr -- 到期日期
    ,scfxrq -- 首次付息日期
    ,fxpl -- 付息频率
    ,jxjz -- 计息基准
    ,tzye -- 投资余额
    ,zmye -- 账面余额
    ,dqgyjgbdsy -- 当前公允价值变动损益
    ,drlxsr -- 当日利息收入
    ,dylxsr -- 当月利息收入
    ,bnlxsr -- 本年利息收入(元)
    ,ljlxsr -- 累计利息收入
    ,drlxzc -- 当日利息支出(元)
    ,dylxzc -- 当月利息支出
    ,djlxzc -- 当季利息支出
    ,dnlxzc -- 本年利息支出(元)
    ,lxsrzzs -- 利息收入增值税(元),
    ,bnmmsy -- 半年买卖损益
    ,ljmmsy -- 累计买卖损益
    ,yzbwlx -- 已转表外利息(元)
    ,bjkmh -- 本金科目号
    ,bjkmmc -- 本金科目名称
    ,ftpll -- 准备金ftp利率
    ,zhnrjye -- 账户年日均余额
    ,zhjrjye -- 账户季日均余额
    ,zhyrjye -- 账户月日均余额
    ,fphyrj -- 分配后月日均
    ,fphjrj -- 分配后季日均
    ,fphnrj -- 分配后年日均
    ,zjsr -- 中间收入
    ,ftpsyrlj -- ftp收益日累计
    ,ftpsyylj -- ftp收益月累计
    ,ftpsynlj -- ftp收益年累计
    ,ftpsyljlj -- ftp收益累计累计
    ,fpjs -- 分配角色
    ,khdxdh -- 考核对象代号
    ,zlbl -- 增量比例
    ,xplx -- 息票类型
    ,jydslxms -- 交易对手类型描述
    ,sjrzrlxms -- 事件rzrlxms
    ,jxjzms -- 结息基准描述
    ,cplxmc -- 产品类型名称
    ,tzid -- 投组id
    ,sjly -- 数据来源
    ,hydh -- 行员代号
    ,hymc -- 行员名称
    ,ssjgdh -- 机构代号
    ,fptx -- 所属条线
    ,txfpbl -- 条线分配比例
    ,ssjgmc -- 机构名称
    ,hsfxjqzcje -- 缓释后的风险加权资产金额
    ,tzsy -- 调整收益
    ,tzsyylj -- 调整收益月累计
    ,tzsyjlj -- 调整收益季累计
    ,tzsynlj -- 调整收益年累计
    ,blqtzsy -- 补录前调整收益
    ,blqtzsyylj -- 补录前调整收益月累计
    ,blqtzsyjlj -- 补录前调整收益季累计
    ,blqtzsynlj -- 补录前调整收益年累计
    ,blsyje -- 补录收益金额
    ,blsyjeylj -- 补录收益金额月累计
    ,blsyjejlj -- 补录收益金额季累计
    ,blsyjenlj -- 补录收益金额年累计
    ,jgkhdxdh -- 机构考核对象代号
    ,ljtzysje -- 累计调整营收金额
    ,tzhljftpjsy -- 调整后累计ftp净收益
    ,ljtzfyje -- 累计调整费用金额
    ,jjljftpjsy -- 计奖累计ftp净收益
    ,dytzysje -- 月累计调整营收金额
    ,tzhdyftpjsy -- 调整后月累计ftp净收益
    ,dytzfyje -- 月累计调整费用金额
    ,jjdyftpjsy -- 计奖月累计ftp净收益
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxbb_tyffzckmx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_jxbb_tyffzckmx exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_tyffzckmx_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_tyffzckmx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_jxbb_tyffzckmx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_tyffzckmx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);