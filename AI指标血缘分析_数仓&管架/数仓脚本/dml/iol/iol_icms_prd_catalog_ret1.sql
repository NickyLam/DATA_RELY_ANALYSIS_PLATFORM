/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_PRD_CATALOG_ret1
CreateDate: 20240712_月度版本
Logs:
     SUNDEXIN 新建脚本 
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
                       FROM ICMS_PRD_CATALOG_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_PRD_CATALOG');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_PRD_CATALOG drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_PRD_CATALOG add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_PRD_CATALOG(
            productid -- 产品编号
            ,expirydate -- 产品失效日期
            ,indpostloancheckrate -- 个人客户贷后检查抽取比例
            ,parentproductid -- 父目录
            ,productclassify -- 新增产品类型
            ,permitpackage -- 是否允许打包
            ,occupylimitdesc -- 额度占用说明
            ,publiclimit -- 是否公开额度
            ,multiloan -- 是否允许多次放款
            ,updatedate -- 更新日期
            ,exflusiveflag -- 是否专属产品
            ,uniquesuitscope -- 唯一性适用范围
            ,iscapitalpurposecheck -- 是否进行资金用途检查
            ,packageproduct -- 打包业务品种
            ,businessflag -- 是否额度类产品
            ,productstatus -- 产品状态
            ,updateorgid -- 更新机构
            ,belongdept -- 隶属管理部门
            ,multiputout -- 是否允许多次出账
            ,purposechecktopdays -- 资金用途检查天数上限
            ,purposecheckbottomdays -- 资金用途检查天数下限
            ,corporgid -- 法人机构编号
            ,occupylimit -- 是否会占用额度(自用/他用/同业)
            ,earlyrepayment -- 是否允许提前还款
            ,offsheetflag -- 表内外属性
            ,suitcurrency -- 可用币种
            ,inputorgid -- 登记机构
            ,uniquelimit -- 额度是否唯一
            ,suitroles -- 适用角色
            ,belongproductid -- 所属产品编号
            ,baseproduct -- 期限值(月)
            ,productname -- 产品名称
            ,underproduct -- 额度适用产品
            ,limitrelaprotocal -- 额度是否关联协议
            ,productdesc -- 产品描述
            ,basetermmodelno -- 基础条款模型编号
            ,relatermmodelno -- 关联条款模型编号
            ,effectivedate -- 产品生效日期
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,usabledept -- 产品发行机构编号
            ,producttype -- 产品类型
            ,limitperiod -- 额度管控阶段
            ,updateuserid -- 更新人
            ,assetthreetype -- 三分类标识
            ,occupytype -- 额度被占用方式
            ,rotative -- 循环贷款标志
            ,sortno -- 排序号
            ,norisk -- 是否无风险业务
            ,totalexposure -- 是否全敞口业务
            ,isleafnode -- 是否叶节点
            ,entcreditclassify -- 企业征信分类-CreditType
            ,saveflag -- 保存标识
            ,queryparam -- 额度查询参数
            ,isgrouplimit -- 
            ,iscallimit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            productid -- 产品编号
            ,expirydate -- 产品失效日期
            ,indpostloancheckrate -- 个人客户贷后检查抽取比例
            ,parentproductid -- 父目录
            ,productclassify -- 新增产品类型
            ,permitpackage -- 是否允许打包
            ,occupylimitdesc -- 额度占用说明
            ,publiclimit -- 是否公开额度
            ,multiloan -- 是否允许多次放款
            ,updatedate -- 更新日期
            ,exflusiveflag -- 是否专属产品
            ,uniquesuitscope -- 唯一性适用范围
            ,iscapitalpurposecheck -- 是否进行资金用途检查
            ,packageproduct -- 打包业务品种
            ,businessflag -- 是否额度类产品
            ,productstatus -- 产品状态
            ,updateorgid -- 更新机构
            ,belongdept -- 隶属管理部门
            ,multiputout -- 是否允许多次出账
            ,purposechecktopdays -- 资金用途检查天数上限
            ,purposecheckbottomdays -- 资金用途检查天数下限
            ,corporgid -- 法人机构编号
            ,occupylimit -- 是否会占用额度(自用/他用/同业)
            ,earlyrepayment -- 是否允许提前还款
            ,offsheetflag -- 表内外属性
            ,suitcurrency -- 可用币种
            ,inputorgid -- 登记机构
            ,uniquelimit -- 额度是否唯一
            ,suitroles -- 适用角色
            ,belongproductid -- 所属产品编号
            ,baseproduct -- 期限值(月)
            ,productname -- 产品名称
            ,underproduct -- 额度适用产品
            ,limitrelaprotocal -- 额度是否关联协议
            ,productdesc -- 产品描述
            ,basetermmodelno -- 基础条款模型编号
            ,relatermmodelno -- 关联条款模型编号
            ,effectivedate -- 产品生效日期
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,usabledept -- 产品发行机构编号
            ,producttype -- 产品类型
            ,limitperiod -- 额度管控阶段
            ,updateuserid -- 更新人
            ,assetthreetype -- 三分类标识
            ,occupytype -- 额度被占用方式
            ,rotative -- 循环贷款标志
            ,sortno -- 排序号
            ,norisk -- 是否无风险业务
            ,totalexposure -- 是否全敞口业务
            ,isleafnode -- 是否叶节点
            ,entcreditclassify -- 企业征信分类-CreditType
            ,saveflag -- 保存标识
            ,queryparam -- 额度查询参数
            ,' ' AS isgrouplimit -- 
            ,' ' AS iscallimit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_PRD_CATALOG_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
