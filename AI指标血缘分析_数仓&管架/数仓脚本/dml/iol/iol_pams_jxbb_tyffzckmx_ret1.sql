/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_tyffzckmx_ret1
CreateDate: 20250630
*/

set timing on
-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;

declare
  v_flag   number(10) :=0;

begin
  for tb in (select partition_name,table_name,substr(partition_name,3) as etl_dt
               from user_tab_partitions
                   where table_name = upper('pams_jxbb_tyffzckmx_bak${batch_date}')
                       and partition_name <> 'P_19000101'
                       --and substr(partition_name,3) = '${batch_date}'
             ) loop

  select count(*) into v_flag
    from all_tab_partitions
   where table_owner = upper('iol')
     and table_name = upper('pams_jxbb_tyffzckmx')
     and partition_name = tb.partition_name;

  if v_flag <> 0 then
    execute immediate 'alter table pams_jxbb_tyffzckmx drop partition '|| tb.partition_name ;
  end if;

    execute immediate 'alter table pams_jxbb_tyffzckmx add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';


-- 回插所有数据

insert /*+ append */ into ${iol_schema}.pams_jxbb_tyffzckmx (
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
	,hsfxjqzcje -- 0
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
	tjrq as tjrq -- 统计日期
	,jxdxdh as jxdxdh -- 绩效对象代号
	,ywbh as ywbh -- 业务编号
	,jrgjdm as jrgjdm -- 金融工具代码
	,jrgjmc as jrgjmc -- 金融工具名称
	,jyssjgdh as jyssjgdh -- 交易所属机构
	,jgmc as jgmc -- 机构名称
	,kjfl as kjfl -- 会计分类
	,cplx as cplx -- 产品类型
	,jyrq as jyrq -- 交易日期
	,jydskhh as jydskhh -- 交易对手客户号
	,jyds as jyds -- 交易对手
	,jydslx as jydslx -- 交易对手客户分类
	,sjrzrkhh as sjrzrkhh -- 发行人/实际融资人客户号
	,sjrzr as sjrzr -- 发行人/实际融资人
	,sjrzrlx as sjrzrlx -- 实际融资人客户分类
	,bz as bz -- 币种
	,tzbj as tzbj -- 投资本金(元)
	,zxll as zxll -- 执行利率
	,qxr as qxr -- 起息日
	,dqr as dqr -- 到期日期
	,scfxrq as scfxrq -- 首次付息日期
	,fxpl as fxpl -- 付息频率
	,jxjz as jxjz -- 计息基准
	,tzye as tzye -- 投资余额
	,zmye as zmye -- 账面余额
	,dqgyjgbdsy as dqgyjgbdsy -- 当前公允价值变动损益
	,drlxsr as drlxsr -- 当日利息收入
	,dylxsr as dylxsr -- 当月利息收入
	,bnlxsr as bnlxsr -- 本年利息收入(元)
	,ljlxsr as ljlxsr -- 累计利息收入
	,drlxzc as drlxzc -- 当日利息支出(元)
	,dylxzc as dylxzc -- 当月利息支出
	,djlxzc as djlxzc -- 当季利息支出
	,dnlxzc as dnlxzc -- 本年利息支出(元)
	,lxsrzzs as lxsrzzs -- 利息收入增值税(元),
	,bnmmsy as bnmmsy -- 半年买卖损益
	,ljmmsy as ljmmsy -- 累计买卖损益
	,yzbwlx as yzbwlx -- 已转表外利息(元)
	,bjkmh as bjkmh -- 本金科目号
	,bjkmmc as bjkmmc -- 本金科目名称
	,ftpll as ftpll -- 准备金ftp利率
	,zhnrjye as zhnrjye -- 账户年日均余额
	,zhjrjye as zhjrjye -- 账户季日均余额
	,zhyrjye as zhyrjye -- 账户月日均余额
	,fphyrj as fphyrj -- 分配后月日均
	,fphjrj as fphjrj -- 分配后季日均
	,fphnrj as fphnrj -- 分配后年日均
	,zjsr as zjsr -- 中间收入
	,ftpsyrlj as ftpsyrlj -- ftp收益日累计
	,ftpsyylj as ftpsyylj -- ftp收益月累计
	,ftpsynlj as ftpsynlj -- ftp收益年累计
	,ftpsyljlj as ftpsyljlj -- ftp收益累计累计
	,fpjs as fpjs -- 分配角色
	,khdxdh as khdxdh -- 考核对象代号
	,zlbl as zlbl -- 增量比例
	,xplx as xplx -- 息票类型
	,jydslxms as jydslxms -- 交易对手类型描述
	,sjrzrlxms as sjrzrlxms -- 事件rzrlxms
	,jxjzms as jxjzms -- 结息基准描述
	,cplxmc as cplxmc -- 产品类型名称
	,tzid as tzid -- 投组id
	,sjly as sjly -- 数据来源
	,hydh as hydh -- 行员代号
	,hymc as hymc -- 行员名称
	,ssjgdh as ssjgdh -- 机构代号
	,fptx as fptx -- 所属条线
	,txfpbl as txfpbl -- 条线分配比例
	,ssjgmc as ssjgmc -- 机构名称
	,hsfxjqzcje as hsfxjqzcje -- 0
	,tzsy as tzsy -- 调整收益
	,tzsyylj as tzsyylj -- 调整收益月累计
	,tzsyjlj as tzsyjlj -- 调整收益季累计
	,tzsynlj as tzsynlj -- 调整收益年累计
	,blqtzsy as blqtzsy -- 补录前调整收益
	,blqtzsyylj as blqtzsyylj -- 补录前调整收益月累计
	,blqtzsyjlj as blqtzsyjlj -- 补录前调整收益季累计
	,blqtzsynlj as blqtzsynlj -- 补录前调整收益年累计
	,blsyje as blsyje -- 补录收益金额
	,blsyjeylj as blsyjeylj -- 补录收益金额月累计
	,blsyjejlj as blsyjejlj -- 补录收益金额季累计
	,blsyjenlj as blsyjenlj -- 补录收益金额年累计
	,jgkhdxdh as jgkhdxdh -- 机构考核对象代号
	,ljtzysje as ljtzysje -- 累计调整营收金额
	,tzhljftpjsy as tzhljftpjsy -- 调整后累计ftp净收益
	,ljtzfyje as ljtzfyje -- 累计调整费用金额
	,jjljftpjsy as jjljftpjsy -- 计奖累计ftp净收益
	,0 as dytzysje -- 月累计调整营收金额
	,0 as tzhdyftpjsy -- 调整后月累计ftp净收益
	,0 as dytzfyje -- 月累计调整费用金额
	,0 as jjdyftpjsy -- 计奖月累计ftp净收益	
	,etl_dt as etl_dt -- ETL处理日期
	,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.pams_jxbb_tyffzckmx_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;

end loop;
end;
/

