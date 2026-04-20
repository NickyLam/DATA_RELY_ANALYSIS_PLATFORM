/**
 * 骨架屏组件
 * 用于数据加载时展示占位符，提升用户体验
 */

import React from 'react';

interface SkeletonProps {
  variant?: 'text' | 'circle' | 'rect' | 'card';
  width?: number | string;
  height?: number | string;
  count?: number;
  animation?: 'pulse' | 'wave' | 'none';
  className?: string;
}

const Skeleton: React.FC<SkeletonProps> = ({
  variant = 'text',
  width,
  height,
  count = 1,
  animation = 'pulse',
  className = '',
}) => {
  const getBaseStyle = (): React.CSSProperties => {
    const base: React.CSSProperties = {
      backgroundColor: '#f0f0f0',
      borderRadius: variant === 'circle' ? '50%' : '4px',
    };

    if (width) {
      base.width = typeof width === 'number' ? `${width}px` : width;
    } else {
      switch (variant) {
        case 'text':
          base.width = '100%';
          break;
        case 'circle':
          base.width = '40px';
          break;
        case 'rect':
          base.width = '100%';
          break;
        case 'card':
          base.width = '100%';
          break;
      }
    }

    if (height) {
      base.height = typeof height === 'number' ? `${height}px` : height;
    } else {
      switch (variant) {
        case 'text':
          base.height = '16px';
          break;
        case 'circle':
          base.height = '40px';
          break;
        case 'rect':
          base.height = '100px';
          break;
        case 'card':
          base.height = '200px';
          break;
      }
    }

    return base;
  };

  const getAnimationClass = (): string => {
    switch (animation) {
      case 'pulse':
        return 'skeleton-pulse';
      case 'wave':
        return 'skeleton-wave';
      default:
        return '';
    }
  };

  const elements = [];
  for (let i = 0; i < count; i++) {
    elements.push(
      <div
        key={i}
        className={`${getAnimationClass()} ${className}`}
        style={{
          ...getBaseStyle(),
          marginBottom: i < count - 1 ? '8px' : 0,
        }}
      />
    );
  }

  return <div>{elements}</div>;
};

// 表格骨架屏
export const TableSkeleton: React.FC<{ rows?: number; columns?: number }> = ({
  rows = 5,
  columns = 4,
}) => (
  <div className="skeleton-table">
    {/* Header */}
    <div className="skeleton-table-header" style={{ display: 'flex', gap: '16px', padding: '12px', borderBottom: '1px solid #e8e8e8' }}>
      {Array.from({ length: columns }).map((_, i) => (
        <Skeleton key={i} variant="text" width="100%" height="20px" />
      ))}
    </div>
    {/* Rows */}
    {Array.from({ length: rows }).map((_, rowIndex) => (
      <div
        key={rowIndex}
        className="skeleton-table-row"
        style={{ display: 'flex', gap: '16px', padding: '12px' }}
      >
        {Array.from({ length: columns }).map((_, colIndex) => (
          <Skeleton key={colIndex} variant="text" width="100%" height="16px" />
        ))}
      </div>
    ))}
  </div>
);

// 卡片骨架屏
export const CardSkeleton: React.FC<{ count?: number }> = ({ count = 1 }) => (
  <div style={{ display: 'flex', gap: '16px', flexWrap: 'wrap' }}>
    {Array.from({ length: count }).map((_, i) => (
      <div key={i} className="skeleton-card" style={{ width: '300px', padding: '16px', border: '1px solid #e8e8e8', borderRadius: '8px' }}>
        <Skeleton variant="rect" height="120px" />
        <div style={{ marginTop: '12px' }}>
          <Skeleton variant="text" width="80%" height="20px" />
          <Skeleton variant="text" width="60%" height="16px" count={2} />
        </div>
      </div>
    ))}
  </div>
);

// 血缘图谱骨架屏
export const LineageGraphSkeleton: React.FC = () => (
  <div className="skeleton-lineage" style={{ width: '100%', height: '500px', display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
    <div style={{ textAlign: 'center' }}>
      <Skeleton variant="circle" width="60px" height="60px" />
      <div style={{ marginTop: '24px', display: 'flex', gap: '100px' }}>
        <div>
          <Skeleton variant="rect" width="80px" height="40px" />
          <Skeleton variant="text" width="80px" height="16px" style={{ marginTop: '8px' }} />
        </div>
        <div>
          <Skeleton variant="rect" width="80px" height="40px" />
          <Skeleton variant="text" width="80px" height="16px" style={{ marginTop: '8px' }} />
        </div>
      </div>
      <Skeleton variant="text" width="200px" height="16px" style={{ marginTop: '24px' }} />
    </div>
  </div>
);

// 搜索结果骨架屏
export const SearchResultsSkeleton: React.FC<{ count?: number }> = ({ count = 5 }) => (
  <div className="skeleton-search-results">
    {Array.from({ length: count }).map((_, i) => (
      <div key={i} className="skeleton-search-item" style={{ padding: '12px', border: '1px solid #e8e8e8', borderRadius: '4px', marginBottom: '8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
          <Skeleton variant="circle" width="40px" height="40px" />
          <div style={{ flex: 1 }}>
            <Skeleton variant="text" width="60%" height="20px" />
            <Skeleton variant="text" width="40%" height="16px" />
          </div>
        </div>
      </div>
    ))}
  </div>
);

// 页面骨架屏
export const PageSkeleton: React.FC<{ type?: 'list' | 'detail' | 'graph' }> = ({
  type = 'list',
}) => {
  switch (type) {
    case 'list':
      return <TableSkeleton />;
    case 'detail':
      return (
        <div style={{ padding: '24px' }}>
          <Skeleton variant="text" width="40%" height="28px" />
          <div style={{ marginTop: '24px' }}>
            <CardSkeleton count={2} />
          </div>
        </div>
      );
    case 'graph':
      return <LineageGraphSkeleton />;
    default:
      return <TableSkeleton />;
  }
};

export default Skeleton;