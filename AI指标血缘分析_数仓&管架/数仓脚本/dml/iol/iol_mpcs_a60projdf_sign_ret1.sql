/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a60projdf_sign
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM mpcs_a60projdf_sign_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('mpcs_a60projdf_sign');
  
  if v_var <> 0 then 
    execute immediate 'alter table mpcs_a60projdf_sign drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table mpcs_a60projdf_sign add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    

insert /*+ append */ into ${iol_schema}.mpcs_a60projdf_sign(
            projno -- 项目号
            ,projtp -- 项目名称: 00.代扣 05.代发  09.开卡
            ,acctno -- 委托单位账号
            ,acctna -- 委托单位名称
            ,offitl -- 单位电话
            ,mailad -- 地址
            ,glacno -- 内部账户
            ,glacna -- 内部账户名称
            ,bstype -- 业务类别 0 普通代发 1 代报帐 2 其他
            ,wdtype -- 退款方式 0 手工退回 1 自动退回 2 不适用
            ,isnbnk -- 交易渠道 0 柜台 1 网银 9 全部
            ,compco -- 组织机构代码
            ,feeamo -- 网银代发手续费
            ,dracno -- 扣收手续费账号
            ,dracna -- 手续费账户名称
            ,coyhbl -- 客户优惠率
            ,yhendt -- 优惠截止日期
            ,signdt -- 签约日期
            ,cntrbr -- 签约机构
            ,crtrus -- 受理柜员
            ,modidt -- 修改日期
            ,mdtrbr -- 修改机构
            ,mdtrus -- 修改柜员
            ,cntrst -- 协议状态  1-正常0-关闭
            ,closdt -- 解约日期
            ,closus -- 解约柜员
            ,custno -- 客户号
            ,otherflag -- 他行标识 0-本行 1-他行
            ,otheracctno -- 他行账号
            ,otheracctna -- 他行户名
            ,otherbankno -- 他行行号
            ,otherbankna -- 他行行名
            ,inneracno -- 过渡内部户账号
            ,inneracna -- 过渡内部户户名
            ,tkflag -- 退款标志
            ,lmtamtflg -- 限额类型：1-全局限额 2-客户自定义月累计限额
            ,monthlmtamt -- 月累计限额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
             projno -- 项目号
            ,projtp -- 项目名称: 00.代扣 05.代发  09.开卡
            ,acctno -- 委托单位账号
            ,acctna -- 委托单位名称
            ,offitl -- 单位电话
            ,mailad -- 地址
            ,glacno -- 内部账户
            ,glacna -- 内部账户名称
            ,bstype -- 业务类别 0 普通代发 1 代报帐 2 其他
            ,wdtype -- 退款方式 0 手工退回 1 自动退回 2 不适用
            ,isnbnk -- 交易渠道 0 柜台 1 网银 9 全部
            ,compco -- 组织机构代码
            ,feeamo -- 网银代发手续费
            ,dracno -- 扣收手续费账号
            ,dracna -- 手续费账户名称
            ,coyhbl -- 客户优惠率
            ,yhendt -- 优惠截止日期
            ,signdt -- 签约日期
            ,cntrbr -- 签约机构
            ,crtrus -- 受理柜员
            ,modidt -- 修改日期
            ,mdtrbr -- 修改机构
            ,mdtrus -- 修改柜员
            ,cntrst -- 协议状态  1-正常0-关闭
            ,closdt -- 解约日期
            ,closus -- 解约柜员
            ,custno -- 客户号
            ,otherflag -- 他行标识 0-本行 1-他行
            ,otheracctno -- 他行账号
            ,otheracctna -- 他行户名
            ,otherbankno -- 他行行号
            ,otherbankna -- 他行行名
            ,inneracno -- 过渡内部户账号
            ,inneracna -- 过渡内部户户名
            ,tkflag -- 退款标志
            ,' ' as lmtamtflg -- 限额类型：1-全局限额 2-客户自定义月累计限额
            ,' ' as monthlmtamt -- 月累计限额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a60projdf_sign_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
