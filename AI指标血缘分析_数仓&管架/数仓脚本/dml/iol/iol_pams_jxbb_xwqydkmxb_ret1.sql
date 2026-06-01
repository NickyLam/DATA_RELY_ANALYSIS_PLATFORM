/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_xwqydkmxb_ret1
CreateDate: 20250801
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
                   where table_name = upper('pams_jxbb_xwqydkmxb_bak${batch_date}')
                       and partition_name <> 'P_19000101'
                       --and substr(partition_name,3) = '${batch_date}'
             ) loop

  select count(*) into v_flag
    from all_tab_partitions
   where table_owner = upper('iol')
     and table_name = upper('pams_jxbb_xwqydkmxb')
     and partition_name = tb.partition_name;

  if v_flag <> 0 then
    execute immediate 'alter table pams_jxbb_xwqydkmxb drop partition '|| tb.partition_name ;
  end if;

    execute immediate 'alter table pams_jxbb_xwqydkmxb add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';


-- 回插所有数据

insert /*+ append */ into ${iol_schema}.pams_jxbb_xwqydkmxb (
	tjrq -- 统计日期
	,jxdxdh -- 绩效对象代号
	,jgkhdxdh -- 机构考核对象代号
	,jgdh -- 机构代号
	,jgmc -- 机构名称
	,jjh -- 借据号
	,khh -- 客户号
	,khmc -- 客户名称
	,dklx -- 贷款类型
	,sfxw -- 是否小微标识
	,ywpz -- 业务配置
	,kmh -- 科目号
	,kmmc -- 科目名称
	,ffrq -- 发放日期
	,dqrq -- 到期日期
	,bzzwmc -- 币种
	,dkje -- 贷款金额
	,zcye -- 正常余额
	,zcyrj -- 正常月日均
	,zcjrj -- 正常季日均
	,zcnrj -- 正常年日均
	,yqye -- 逾期余额
	,yqyrj -- 逾期月日均
	,yqjrj -- 逾期季日均
	,yqnrj -- 逾期年日均
	,nll -- 年利率
	,jzll -- 基准利率
	,khdxdh -- 考核对象代号
	,hydh -- 客户经理工号
	,hymc -- 客户经理名称
	,ssjgkhdxdh -- 所属机构考核对象代号
	,ssjgdh -- 所属机构号
	,ssjgmc -- 所属机构名称
	,fpje -- 分配总金额
	,zlbl -- 分配比例
	,fphzcye -- 分配后正常余额
	,fphzcyrj -- 分配后正常月日均
	,fphzcjrj -- 分配后正常季日均
	,fphzcnrj -- 分配后正常年日均
	,fphyqye -- 分配后逾期余额
	,fphyqyrj -- 分配后逾期月日均
	,fphyqjrj -- 分配后逾期季日均
	,fphyqnrj -- 分配后逾期年日均
	,gyljrywbz -- 供应链金融业务标志
	,ftplxsr -- FTP利息收入
	,ylx -- 月利息
	,nlx -- 年利息
	,ftpzycb -- FTP转移成本
	,dyftpzycb -- 当月FTP转移成本
	,ljftpzycb -- 累计FTP转移成本
	,ftpsy -- FTP收益
	,dyftpjsy -- 当月FTP净收益
	,ljftpjsy -- 累计FTP净收益
	,xbcxdbs -- 1+N信保贷标识
	,etl_dt -- ETL处理日期
	,etl_timestamp -- ETL处理时间戳
)
select
	tjrq as tjrq -- 统计日期
	,jxdxdh as jxdxdh -- 绩效对象代号
	,jgkhdxdh as jgkhdxdh -- 机构考核对象代号
	,jgdh as jgdh -- 机构代号
	,jgmc as jgmc -- 机构名称
	,jjh as jjh -- 借据号
	,khh as khh -- 客户号
	,khmc as khmc -- 客户名称
	,dklx as dklx -- 贷款类型
	,sfxw as sfxw -- 是否小微标识
	,ywpz as ywpz -- 业务配置
	,kmh as kmh -- 科目号
	,kmmc as kmmc -- 科目名称
	,ffrq as ffrq -- 发放日期
	,dqrq as dqrq -- 到期日期
	,bzzwmc as bzzwmc -- 币种
	,dkje as dkje -- 贷款金额
	,zcye as zcye -- 正常余额
	,zcyrj as zcyrj -- 正常月日均
	,zcjrj as zcjrj -- 正常季日均
	,zcnrj as zcnrj -- 正常年日均
	,yqye as yqye -- 逾期余额
	,yqyrj as yqyrj -- 逾期月日均
	,yqjrj as yqjrj -- 逾期季日均
	,yqnrj as yqnrj -- 逾期年日均
	,nll as nll -- 年利率
	,jzll as jzll -- 基准利率
	,khdxdh as khdxdh -- 考核对象代号
	,hydh as hydh -- 客户经理工号
	,hymc as hymc -- 客户经理名称
	,ssjgkhdxdh as ssjgkhdxdh -- 所属机构考核对象代号
	,ssjgdh as ssjgdh -- 所属机构号
	,ssjgmc as ssjgmc -- 所属机构名称
	,fpje as fpje -- 分配总金额
	,zlbl as zlbl -- 分配比例
	,fphzcye as fphzcye -- 分配后正常余额
	,fphzcyrj as fphzcyrj -- 分配后正常月日均
	,fphzcjrj as fphzcjrj -- 分配后正常季日均
	,fphzcnrj as fphzcnrj -- 分配后正常年日均
	,fphyqye as fphyqye -- 分配后逾期余额
	,fphyqyrj as fphyqyrj -- 分配后逾期月日均
	,fphyqjrj as fphyqjrj -- 分配后逾期季日均
	,fphyqnrj as fphyqnrj -- 分配后逾期年日均
	,gyljrywbz as gyljrywbz -- 供应链金融业务标志
	,ftplxsr as ftplxsr -- FTP利息收入
	,ylx as ylx -- 月利息
	,nlx as nlx -- 年利息
	,ftpzycb as ftpzycb -- FTP转移成本
	,dyftpzycb as dyftpzycb -- 当月FTP转移成本
	,ljftpzycb as ljftpzycb -- 累计FTP转移成本
	,ftpsy as ftpsy -- FTP收益
	,dyftpjsy as dyftpjsy -- 当月FTP净收益
	,ljftpjsy as ljftpjsy -- 累计FTP净收益
	,' ' as xbcxdbs -- 1+N信保贷标识
	,etl_dt as etl_dt -- ETL处理日期
	,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.pams_jxbb_xwqydkmxb_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;

end loop;
end;
/

